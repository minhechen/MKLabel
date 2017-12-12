//
//  ViewController.swift
//  MKLabel
//
//  Created by AC-Mac on 16/11/2017.
//  Copyright © 2017 MackChan  minhechen@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let baseY: CGFloat = 40.0
    var clickButton: UIButton?
    var mkLabelNormal: MKLabel?
    var mkLabelAscend: MKLabel?
    var mkLabelDescend: MKLabel?
    var mkLabelMiddle: MKLabel?
    var mainTableView: UITableView?
    var temView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //sleep(3)
        // Do any additional setup after loading the view, typically from a nib.
        
        self.addNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewContent() -> Void {
        
        if temView == nil {
            temView = UIView.init(frame: self.view.bounds)
            self.view.addSubview(temView)
            
            clickButton = UIButton(frame: CGRect(x: 0, y: 40 + baseY, width: self.view.frame.size.width, height: 44))
            clickButton?.setTitle("Click", for: UIControlState.normal)
            clickButton?.addTarget(self, action: #selector(ViewController.startFadeLabelAnimation), for: UIControlEvents.touchUpInside)
            clickButton?.backgroundColor = UIColor.red
            clickButton?.layer.cornerRadius = 4.0
            
            temView.addSubview(clickButton!)
            
            mkLabelNormal = MKLabel(frame: CGRect(x: 0, y: 90 + baseY, width: self.view.frame.size.width, height: 100))
            mkLabelNormal?.text = "Do any additional setup after loading the view, typically from a nib,Do any additional setup after loading the view, typically from a nib,"
            mkLabelNormal?.numberOfLines = 0
            mkLabelNormal?.lineBreakMode = .byWordWrapping
            mkLabelNormal?.textAlignment = .center
            mkLabelNormal?.font = UIFont.systemFont(ofSize: 16)
            mkLabelNormal?.backgroundColor = UIColor.red
            mkLabelNormal?.beginFadeAnimation(isFadeIn: true, completionBlock: { (finished, text) in
                print("animation finished")
            })
            temView.addSubview(mkLabelNormal!)
            
            /// Ascend display label
            mkLabelAscend = MKLabel(frame: CGRect(x: 0, y: 210 + baseY, width: self.view.frame.size.width, height: 100))
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
            temView.addSubview(mkLabelAscend!)
            
            /// Descend display label
            mkLabelDescend = MKLabel(frame: CGRect(x: 0, y: 330 + baseY, width: self.view.frame.size.width, height: 100))
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
            
            temView.addSubview(mkLabelDescend!)
            
            /// Middle display label
            mkLabelMiddle = MKLabel(frame: CGRect(x: 0, y: 450 + baseY, width: self.view.frame.size.width, height: 100))
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
            temView.addSubview(mkLabelMiddle!)

        }
        
    }
    
    func addNotification() -> Void {
        NotificationCenter.default.addObserver(self
            , selector: #selector(ViewController.startFadeLabelAnimation), name: NSNotification.Name(rawValue:"startFadeLabelAnimation"), object: nil)
    }
    
    func setUpContentView() -> Void {
        mainTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mainTableView?.dataSource = self
        mainTableView?.delegate = self
        self.view.addSubview(mainTableView!)
        
    }

    // MARK: -
    // MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func startFadeLabelAnimation() {
        if temView == nil {
            self.setUpViewContent()
        }else{
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
}

