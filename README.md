# MKFadeLabel
## create a fantastic UILabel with fade in or fade out effect
```
mkLabelNormal = MKFadeLabel(frame: CGRect(x: 0, y: 90, width: self.view.frame.size.width, height: 100))
mkLabelNormal?.text = "Do any additional setup after loading the view, typically from a nib,Do any additional setup after loading the view, typically from a nib,"
mkLabelNormal?.beginFadeAnimation(isFadeIn: true, completionBlock: { (finished, text) in
            print("animation finished")
        })
```

## you can also create other three fade in or fade out effect by ```enum```:
```
enum MKFadeLabelDisplayType {
    case normal // Irregular fade in or fade out animation
    case ascend // Begin animation from begin to the end
    case descend // Begin animation from end to the begin
    case middle // Begin animation from middle of labe text
    case other // default animation
}
mkLabelAscend = MKFadeLabel(frame: CGRect(x: 0, y: 210, width: self.view.frame.size.width, height: 100))
mkLabelAscend?.text = "Do any additional setup after loading the view, typically from a nib,Do any additional setup after loading the view, typically from a nib"
mkLabelAscend?.beginFadeAnimation(isFadeIn: true, displayType: .ascend, completionBlock: { (finished, text) in
            print("animation finished")
        })
```
