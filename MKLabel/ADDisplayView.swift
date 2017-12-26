//
//  ADDisplayView.swift
//  MKLabel
//
//  Created by AC-Mac on 08/12/2017.
//  Copyright © 2017 MackChan  minhechen@gmail.com. All rights reserved.
//

import UIKit

class ADDisplayView: UIView {

    static let shared: ADDisplayView = ADDisplayView()
    var adImageView: UIImageView?
    var closeAdButton: UIButton?
    var adTimer: Timer?
    var adTimerInternal: Int = 0
    var mkFadeLabel: MKLabel?
    var adDuration: TimeInterval = 6.0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // show the ad view
    func showAdView(_ adImage: UIImage?) -> Void {
        guard adImage != nil else {
            return
        }
        self.frame = UIScreen.main.bounds
        if adImageView == nil {
            adImageView = UIImageView.init(frame: UIScreen.main.bounds)
            self.addSubview(adImageView!)
        }
        adImageView?.image = adImage
        
        if closeAdButton == nil {
            closeAdButton = UIButton.init(frame: CGRect(x: self.frame.size.width - 80, y: 40, width: 40, height: 40))
            closeAdButton?.addTarget(self, action: #selector(ADDisplayView.closeAdAction(_:)), for: UIControlEvents.touchUpInside)
            closeAdButton?.backgroundColor = UIColor.lightGray
            closeAdButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
            // you'd better use corner image or UIBezierPath to set corner
            closeAdButton?.layer.cornerRadius = 20.0
            closeAdButton?.clipsToBounds = true
            self.addSubview(closeAdButton!)
        }
        closeAdButton?.setTitle("3s", for: UIControlState.normal)
        
        self.startTimer()
        UIApplication.shared.delegate?.window??.addSubview(self)
        self.addFadeLabel()
    }
    
    // show the fade label
    func addFadeLabel() -> Void {
        let sWidth = self.frame.size.width
        //let sHeight = self.frame.size.height
        mkFadeLabel = MKLabel(frame: CGRect(x: 0, y: 450, width: sWidth, height: 100))
        mkFadeLabel?.text = "Talk is cheap. Show me the code\n快快参与#微博话题#"
//        mkFadeLabel?.text = "The world is very complex, baidu know you more\n李厂长在此等你#百度一下#"
        mkFadeLabel?.numberOfLines = 0
        mkFadeLabel?.lineBreakMode = .byWordWrapping
        mkFadeLabel?.textAlignment = .center
        mkFadeLabel?.textColor = UIColor.darkGray
        mkFadeLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        mkFadeLabel?.durationTime = 2.0
        mkFadeLabel?.beginFadeAnimation(isFadeIn: true, displayType: .normal, completionBlock: { (finished, text) in
            
        })
        mkFadeLabel?.mkAddAttributeTapAction(nil, highlightTapAction: { (text, range, index) in
            print("tap text is:\(text)")
        })
        self.addSubview(mkFadeLabel!)
    }
    
    // close ad view
    @objc func closeAdAction(_ sender: UIButton) -> Void {
        self.stopTimer()
        self.hideAdView()
    }
    
    // hide ad view with animate
    func hideAdView() -> Void {
        UIView.animate(withDuration: 0.25, animations: { 
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"startFadeLabelAnimation"), object: nil)
        }
    }
    
    // timer actio@objc n
    @objc func timerAction() -> Void {
        if adTimerInternal == 3 {
            print("close ad")
            self.stopTimer()
            self.hideAdView()
        }else{
            closeAdButton?.setTitle("\(3 - adTimerInternal)s", for: UIControlState.normal)
            adTimerInternal += 1
        }
    }
    
    // start timer
    func startTimer() -> Void {
        if adTimer == nil {
            adTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(ADDisplayView.timerAction), userInfo: nil, repeats: true)
            RunLoop.main.add(adTimer!, forMode: .commonModes)
        }
        adTimer?.fire()
    }
    
    // stop timer
    func stopTimer() -> Void {
        if adTimer?.isValid == true {
            adTimer?.invalidate()
            adTimer = nil
        }
    }
}
