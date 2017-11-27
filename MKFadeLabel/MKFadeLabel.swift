//
//  MKLabel.swift
//  MKFadeLabel
//
//  Created by AC-Mac on 16/11/2017.
//  Copyright © 2017 MackChan  minhechen@gmail.com. All rights reserved.
//

import UIKit

enum MKFadeLabelDisplayType {
    case normal
    case ascend
    case descend
    case middle
    case other
}

class MKFadeLabel: UILabel {
    var mkDisplayLink: CADisplayLink?

    private var attributedTextString: NSMutableAttributedString?
    private var delayTimeArray: [Double] = [Double]()
    private var animationTimeArray: [Double] = [Double]()
    let durationTime: CFTimeInterval = 2.5
    var isFadeIn: Bool = false
    private var beginTime: CFTimeInterval?
    private var endTime: CFTimeInterval?
    
    typealias completionBlock = (Bool, String) -> Void
    private var completion: completionBlock? /// animation end block
    fileprivate var displayType: MKFadeLabelDisplayType = .normal /// display type
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        mkDisplayLink = CADisplayLink.init(target: self, selector: #selector(MKFadeLabel.updateLabelDisplay))
        mkDisplayLink?.add(to: .current, forMode: .commonModes)
        mkDisplayLink?.isPaused = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* begin fade in or fade out animation
     * fadeIn: true is fade in false is fade out
    */
    func beginFadeAnimation(isFadeIn fadeIn: Bool, displayType: MKFadeLabelDisplayType = .normal, completionBlock: @escaping completionBlock) {
        self.displayType = displayType
        self.completion = completionBlock
        self.isFadeIn = fadeIn
        self.beginTime = CACurrentMediaTime()
        self.endTime = self.beginTime! + self.durationTime
        self.mkDisplayLink?.isPaused = false
        self.setAttributedTextString(NSAttributedString(string:self.text!))
    }
    
    func setAttributedTextString(_ attributedText: NSAttributedString) {
        self.attributedTextString = self.setAlphaAttributedTextString(attributedText) as? NSMutableAttributedString
        var delayTime = 0.0, animationDuration = 0.0
        let totalLength = attributedText.length
        if delayTimeArray.count > 0 {
            delayTimeArray.removeAll()
            animationTimeArray.removeAll()
        }
        for index in 0..<totalLength {
            
            switch self.displayType {
            case .normal:
            
                delayTime = Double(arc4random_uniform(UInt32(durationTime/2.0 * 100)))/100.0
                let animationTime = durationTime - delayTime
                animationDuration = (Double(arc4random_uniform(UInt32(animationTime * 100)))/100.0)
            case .ascend:
                delayTime = Double((durationTime * Double(index))/Double(totalLength))
                let animationTime = durationTime - delayTime
                animationDuration = animationTime
                if self.isFadeIn == false {
                    if animationTime > delayTime{
                        animationDuration = delayTime
                    }
                }
            case .descend:
                delayTime = Double((durationTime * Double(index))/Double(totalLength))
                let animationTime = durationTime - delayTime
                animationDuration = animationTime
                if self.isFadeIn == false {
                    if animationTime > delayTime{
                        animationDuration = delayTime
                    }
                }
            case .middle:
                delayTime = Double((durationTime * Double(index))/Double(totalLength))
                let animationTime = durationTime - delayTime
                animationDuration = animationTime
                if self.isFadeIn == false {
                    if animationTime > delayTime{
                        animationDuration = delayTime
                    }
                }
            default:
                delayTime = Double(arc4random_uniform(UInt32(durationTime/2.0 * 100)))/100.0
                let animationTime = durationTime - delayTime
                animationDuration = (Double(arc4random_uniform(UInt32(animationTime * 100)))/100.0)
            }
            
            delayTimeArray.append(delayTime)
            animationTimeArray.append(animationDuration)
            if self.displayType == .middle{
                delayTimeArray.reverse()
                animationTimeArray.reverse()
            }
        }
        if self.displayType == .descend{
            delayTimeArray.reverse()
            animationTimeArray.reverse()
        }
    }
    
    func updateLabelDisplay(displayLink: CADisplayLink) -> Void {
        guard self.attributedTextString != nil else {
            return
        }
        guard self.endTime != nil else {
            return
        }
        
        let nowTime = CACurrentMediaTime()
        let attributedLength = self.attributedTextString?.length
        for index in 0..<attributedLength! {
            
            self.attributedTextString?.enumerateAttributes(in: NSMakeRange(index, 1), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired, using: {(value, range, error) -> Void in
                let colorA = value[NSForegroundColorAttributeName] as! UIColor
                let colorAlpha = colorA.cgColor.alpha
                let isNeedUpdate = (nowTime - self.beginTime!) > self.delayTimeArray[index] || (isFadeIn && colorAlpha < 1.0) || (!isFadeIn && colorAlpha > 0.0)
                if isNeedUpdate == false {
                    return
                }
                var percentage = (nowTime - self.beginTime! - self.delayTimeArray[index])/self.animationTimeArray[index]
                if !self.isFadeIn {
                    percentage = 1 - percentage
                }
                let color = self.textColor.withAlphaComponent(CGFloat(percentage))
                self.attributedTextString?.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            })
        }
        super.attributedText = self.attributedTextString
        if nowTime > self.endTime! {
            self.mkDisplayLink?.isPaused = true
            guard self.completion != nil else {
                return
            }
            self.completion!(true, self.text!)
        }
    }
    
    /*
     * set NSAttributedString Attribute
    */
    func setAlphaAttributedTextString(_ attributedText: NSAttributedString) -> NSAttributedString {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        var color = self.textColor.withAlphaComponent(0)
        if self.isFadeIn == false {
            color = self.textColor.withAlphaComponent(1)
        }
        mutableAttributedText.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: 0, length: attributedText.length))
        return mutableAttributedText
    }
    
}
