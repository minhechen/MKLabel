//
//  ViewController.swift
//  MKFadeLabel
//
//  Created by AC-Mac on 16/11/2017.
//  Copyright © 2017 MackChan  minhechen@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var clickButton: UIButton?
    var mkLabelNormal: MKFadeLabel?
    var mkLabelAscend: MKFadeLabel?
    var mkLabelDescend: MKFadeLabel?
    var mkLabelMiddle: MKFadeLabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mkLabelNormal = MKFadeLabel(frame: CGRect(x: 0, y: 90, width: self.view.frame.size.width, height: 100))
        mkLabelNormal?.text = "Do any additional setup after loading the view, typically from a nib,Do any additional setup after loading the view, typically from a nib,"
        mkLabelNormal?.numberOfLines = 0
        mkLabelNormal?.lineBreakMode = .byWordWrapping
        mkLabelNormal?.textAlignment = .center
        mkLabelNormal?.font = UIFont.systemFont(ofSize: 16)
        mkLabelNormal?.backgroundColor = UIColor.red
        mkLabelNormal?.beginFadeAnimation(isFadeIn: true, completionBlock: { (finished, text) in
            print("animation finished")
        })
        self.view.addSubview(mkLabelNormal!)
        
        /// Ascend display label
        mkLabelAscend = MKFadeLabel(frame: CGRect(x: 0, y: 210, width: self.view.frame.size.width, height: 100))
        mkLabelAscend?.text = "swift,#topic# D#o @any additional setup after loading the view, typically nice from@gmail.com a nib,772078507@qq.com after loading the @view, typically from a nibd,Hello"
        mkLabelAscend?.numberOfLines = 0
        mkLabelAscend?.lineBreakMode = .byWordWrapping
        mkLabelAscend?.textAlignment = .center
        mkLabelAscend?.font = UIFont.systemFont(ofSize: 16.0)
        mkLabelAscend?.backgroundColor = UIColor.yellow
        mkLabelAscend?.beginFadeAnimation(isFadeIn: true, displayType: .ascend, completionBlock: { (finished, text) in
            print("animation finished")
        })
        mkLabelAscend?.mkAddAttributeTapAction(nil, highlightTapAction: { (text, range, index) in
            print("click Ascend tag:\(text)")
        })
        self.view.addSubview(mkLabelAscend!)
        
        /// Descend display label
        mkLabelDescend = MKFadeLabel(frame: CGRect(x: 0, y: 330, width: self.view.frame.size.width, height: 100))
        mkLabelDescend?.text = "swift,#topic# D#o @any additional setup after loading the view, typically nice from@gmail.com a nib,772078507@qq.com after loading the @view, typically from a nibd,Hello"
        mkLabelDescend?.numberOfLines = 0
        mkLabelDescend?.lineBreakMode = .byWordWrapping
        mkLabelDescend?.textAlignment = .center
        mkLabelDescend?.font = UIFont.systemFont(ofSize: 16.0)
        mkLabelDescend?.backgroundColor = UIColor.purple
        mkLabelDescend?.beginFadeAnimation(isFadeIn: true, displayType: .descend, completionBlock: { (finished, text) in
            print("click Descend tag:\(text)")
        })
        mkLabelDescend?.mkAddAttributeTapAction(nil, highlightTapAction: { (text, range, index) in
            print("click tag:\(text)")
        })
        self.view.addSubview(mkLabelDescend!)
        
        /// Middle display label
        mkLabelMiddle = MKFadeLabel(frame: CGRect(x: 0, y: 450, width: self.view.frame.size.width, height: 100))
        mkLabelMiddle?.text = "swift,#topic# D#o @any additional setup after loading the view, typically nice from@gmail.com a nib,772078507@qq.com after loading the @view, typically from a nibd,Hello"
        mkLabelMiddle?.numberOfLines = 0
        mkLabelMiddle?.lineBreakMode = .byWordWrapping
        mkLabelMiddle?.textAlignment = .left
        
        mkLabelMiddle?.font = UIFont.systemFont(ofSize: 13.0)
        mkLabelMiddle?.backgroundColor = UIColor.green
        mkLabelMiddle?.beginFadeAnimation(isFadeIn: true, displayType: .middle, completionBlock: { (finished, text) in
            
        })
    mkLabelMiddle?.mkAddAttributeTapAction(["swift","topic","loading","nice","Hello"], highlightTapAction: { (text, range, index) in
            print("tap text is:\(text)")
        })
        self.view.addSubview(mkLabelMiddle!)
        
        clickButton = UIButton(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 44))
        clickButton?.setTitle("Click", for: UIControlState.normal)
        clickButton?.addTarget(self, action: #selector(ViewController.clickedButtonAction(_:)), for: UIControlEvents.touchUpInside)
        clickButton?.backgroundColor = UIColor.red
        clickButton?.layer.cornerRadius = 4.0
        
        self.view.addSubview(clickButton!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func clickedButtonAction(_ sender: AnyObject) {
        if mkLabelNormal?.isFadeIn == true {
            mkLabelNormal?.isFadeIn = false
        }else{
            mkLabelNormal?.isFadeIn = true
        }
        mkLabelNormal?.beginFadeAnimation(isFadeIn: (mkLabelNormal?.isFadeIn)!, completionBlock: {
            (finished: Bool, text: String) in
            NSLog("%@", text)
        })
        
        // Ascend label animation
        if mkLabelAscend?.isFadeIn == true {
            mkLabelAscend?.isFadeIn = false
        }else{
            mkLabelAscend?.isFadeIn = true
        }
        mkLabelAscend?.beginFadeAnimation(isFadeIn: (mkLabelAscend?.isFadeIn)!, displayType: .ascend, completionBlock: {
            (finished: Bool, text: String) in
            NSLog("%@", text)
        })
        
        /// Descend label animation
        if mkLabelDescend?.isFadeIn == true {
            mkLabelDescend?.isFadeIn = false
        }else{
            mkLabelDescend?.isFadeIn = true
        }
        mkLabelDescend?.beginFadeAnimation(isFadeIn: (mkLabelDescend?.isFadeIn)!, displayType: .descend, completionBlock: {
            (finished: Bool, text: String) in
            NSLog("%@", text)
        })
        
        /// Middle label animation
        if mkLabelMiddle?.isFadeIn == true {
            mkLabelMiddle?.isFadeIn = false
        }else{
            mkLabelMiddle?.isFadeIn = true
        }
        mkLabelMiddle?.beginFadeAnimation(isFadeIn: (mkLabelMiddle?.isFadeIn)!, displayType: .middle, completionBlock: {
            (finished: Bool, text: String) in
            NSLog("%@", text)
        })
    }
}

