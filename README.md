MKLabel
==============
[![Build Status](https://travis-ci.org/minhechen/MKLabel.svg?branch=master)](https://travis-ci.org/minhechen/MKLabel)
![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/minhechen/MKLabel/master/LICENSE)&nbsp;

## The uesage example that used in weibo(微博) landing page effect
![Baidu](https://github.com/minhechen/MKLabel/blob/master/MKLabel/ScreenShot/weiboExample.gif)

## The uesage example that used in baidu(百度) landing page effect
![Weibo](https://github.com/minhechen/MKLabel/blob/master/MKLabel/ScreenShot/baiduExample.gif)

## Create a fantastic UILabel with fade in or fade out effect

```
mkLabelNormal = MKLabel(frame: CGRect(x: 0, y: 90, width: self.view.frame.size.width, height: 100))
mkLabelNormal?.text = "Do any additional setup after loading the view, typically from a nib,Do any additional setup after loading the view, typically from a nib,"
mkLabelNormal?.beginFadeAnimation(isFadeIn: true, completionBlock: { (finished, text) in
            print("animation finished")
        })
```

## You can also create other three fade in or fade out effects by ```enum```:
```
enum MKLabelDisplayType {
    case normal // Irregular fade in or fade out animation
    case ascend // Begin animation from begin to the end
    case descend // Begin animation from end to the begin
    case middle // Begin animation from middle of labe text
    case other // default animation
}
mkLabelAscend = MKLabel(frame: CGRect(x: 0, y: 210, width: self.view.frame.size.width, height: 100))
mkLabelAscend?.text = "Do any additional setup after loading the view, typically from a nib,Do any additional setup after loading the view, typically from a nib"
mkLabelAscend?.beginFadeAnimation(isFadeIn: true, displayType: .ascend, completionBlock: { (finished, text) in
            print("animation finished")
        })
```

## You can also create tags within the text and add tap action :
```
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
```

## You can even customize your own tags for the text, only by appoint the tags ```tags``` :
```
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
```
