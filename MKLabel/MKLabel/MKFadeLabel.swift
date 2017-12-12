//
//  MKLabel.swift
//  MKLabel
//
//  Created by AC-Mac on 16/11/2017.
//  Copyright © 2017 MackChan  minhechen@gmail.com. All rights reserved.
//

import UIKit

enum MKLabelDisplayType {
    case normal // Irregular fade in or fade out animation
    case ascend // Begin animation from begin to the end
    case descend // Begin animation from end to the begin
    case middle // Begin animation from middle of labe text
    case other // default animation
}

class MKLabel: UILabel {
    // animation
    var mkDisplayLink: CADisplayLink?
    private var attributedTextString: NSMutableAttributedString?
    private var delayTimeArray: [Double] = [Double]()
    private var animationTimeArray: [Double] = [Double]()
    var durationTime: CFTimeInterval = 2.5
    var isFadeIn: Bool = false
    private var beginTime: CFTimeInterval?
    private var endTime: CFTimeInterval?
    
    typealias completionBlock = (Bool, String) -> Void
    private var completion: completionBlock? /// animation end block
    fileprivate var displayType: MKLabelDisplayType = .normal /// display type
    
    ////////////////////////////////////
    // tags
    fileprivate var tagsModelArray : [MKTagModel] = []
    fileprivate var tagStringArray: [String] = []
    typealias highlightTapAction = (String, NSRange, Int) -> Void
    private var tapAction: highlightTapAction?
    private var isTapActionEnable : Bool?
    private var isTapEffectEnable : Bool = true
    private var tapEffectDictionary : Dictionary<String , NSAttributedString>?
    var tagColor: UIColor = MKColor.withHex("04b7f9")
    /////////////////
    var fontColor:UIColor = UIColor.black
    
    var specialStrings:[String]?
    
    // line space
    var lineSpace: CGFloat = 2.0
    override var lineBreakMode: NSLineBreakMode {
        get {
            return super.lineBreakMode
        }
        set {
            super.lineBreakMode = newValue
        }
    }
    override var font: UIFont! {
        get {
            return super.font
        }
        set {
            super.font = newValue
        }
    }
    override var textAlignment: NSTextAlignment {
        get {
            return super.textAlignment
        }
        set {
            super.textAlignment = newValue
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    /*
    var _text: String?
    override var text: String? {
        get {
            return _text
        }
        set {
            _text = newValue
//            self.sizeToFit()
        }
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        mkDisplayLink = CADisplayLink.init(target: self, selector: #selector(MKLabel.updateLabelDisplay))
        mkDisplayLink?.add(to: .current, forMode: .commonModes)
        mkDisplayLink?.isPaused = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* begin fade in or fade out animation
     * fadeIn: true is fade in false is fade out
    */
    func beginFadeAnimation(isFadeIn fadeIn: Bool, displayType: MKLabelDisplayType = .normal, completionBlock: @escaping completionBlock) {
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
//                let color = self.textColor.withAlphaComponent(CGFloat(percentage))
                let color = colorA.withAlphaComponent(CGFloat(percentage))
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
        //////////////////
        // add line spacing
        let paragraphStyle = self.mkParagraphStyle()
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        // Line spacing attribute
        mutableAttributedText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
        
        return mutableAttributedText
    }
    
    
    // MARK: - Tap Action Main Function
    /**
     * add action for label
     *- parameter strings:   the tags array
     *- parameter highlightTapAction: tab callback
     */
    func mkAddAttributeTapAction( _ tagArray : [String]? , highlightTapAction : @escaping highlightTapAction) -> Void {
        tapAction = highlightTapAction
        if let tArray = tagArray {
            tagStringArray = tArray
        }
        self.setTapActionEnable()
        self.addTagsColorInfo()
        
    }
    
    // make tags model info
    func addTagsColorInfo() {
        if tagStringArray.count > 0 {
            self.addTagsHighlightColor()
        }else{
           self.addDefaultHighlightColor()
        }
    }
    
    // MARK: -
    // MARK: default tags high light color
    fileprivate func addDefaultHighlightColor() -> Void {
        
        // mail pattern
        let mailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let mailMatches = RegexManager.shared.match(input: self.text!, pattern: mailPattern)
        for mItem in mailMatches {
            self.attributedTextString?.addAttribute(NSForegroundColorAttributeName, value: tagColor, range: mItem.range)
            let model = MKTagModel()
            model.range = mItem.range
            model.text = self.text?.substring(with: (self.text?.range(from: mItem.range))!)
            tagsModelArray.append(model)
        }
        
        // @somebody pattern
//        let atPattern = "@.*? "
//        let atPattern = "@(\\S+)\\s"
        let atPattern = "@[^\\.^\\,^\\>^\\<^\\=^\\+^\\-^\\`^\\*^\\@^\\#^\\$^\\%^\\&^\\(^\\)^\\!^\\^\\/^\\?]*?\\s"
        let atMatches = RegexManager.shared.match(input: self.text!, pattern: atPattern)
        for mItem in atMatches {
            let model = MKTagModel()
            model.range = mItem.range
            model.text = self.text?.substring(with: (self.text?.range(from: mItem.range))!)
            self.attributedTextString?.addAttribute(NSForegroundColorAttributeName, value: tagColor, range: mItem.range)
            tagsModelArray.append(model)
        }
        
        // topic pattern
        let topicPattern = "#[^#]+#"
        let topicMatches = RegexManager.shared.match(input: self.text!, pattern: topicPattern)
        for mItem in topicMatches {
            self.attributedTextString?.addAttribute(NSForegroundColorAttributeName, value: tagColor, range: mItem.range)
            let model = MKTagModel()
            model.range = mItem.range
            model.text = self.text?.substring(with: (self.text?.range(from: mItem.range))!)
            tagsModelArray.append(model)
        }
        
        self.attributedText = self.attributedTextString
     
    }
    
    // add tags high light color
    func addTagsHighlightColor() -> Void {
        
        if (tagsModelArray.count) > 0 {
            tagsModelArray.removeAll()
        }
        for mPattern in tagStringArray {
            
            let mMatches = RegexManager.shared.match(input: self.text!, pattern: mPattern)
            for mItem in mMatches {
                self.attributedTextString?.addAttribute(NSForegroundColorAttributeName, value: tagColor, range: mItem.range)
                let model = MKTagModel()
                model.range = mItem.range
                model.text = self.text?.substring(with: (self.text?.range(from: mItem.range))!)
                tagsModelArray.append(model)
            }
        }
        self.attributedText = self.attributedTextString
    }
    
    // MARK: - set tap action
    fileprivate func setTapActionEnable() -> Void {
        
        if self.attributedText?.length == 0 {
            return;
        }
        self.isUserInteractionEnabled = true
        isTapActionEnable = true
    }
    
    fileprivate func mkGetString(_ count : Int) -> String {
        var string = ""
        for _ in 0 ..< count {
            string = string + " "
        }
        return string
    }
    
    /*
     check regular expression
    */
    func checkHttpRegex() {
        do {
            let regex = try NSRegularExpression(pattern: "(?:^|[\\W])((ht|f)tp(s?):\\/\\/|www\\.)(([\\w\\-]+\\.){1,}?([\\w\\-.~]+\\/?)*[\\p{Alnum}.,%_=?&#\\-+()\\[\\]\\*$~@!:/{};']*)", options: .caseInsensitive)
            let result = regex.matches(in: self.text!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (self.text?.characters.count)!))
            if result.count > 0 {
                for checkingRes in result {
                    print("Location:\(checkingRes.range.location), length:\(checkingRes.range.length)")
                }
            }else{
                print("not found")
            }
        } catch  {
            print(error)
        }
        
    }
    
    func mkGetTapFrame(_ point : CGPoint , result : ((_ str : String , _ range : NSRange , _ index : Int) -> Void)) -> Bool {
        
        // to get tap string
        let framesetter = CTFramesetterCreateWithAttributedString(self.attributedText!)

        let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), bezierPath.cgPath, nil)
        
        let totalLines = CTFrameGetLines(ctframe)
        
        let lineCount = CFArrayGetCount(totalLines)
        
        let height = sizeForText(mutableAttrStr: self.attributedText as! NSMutableAttributedString).height
        
        // top and bottom space height
        let spaceHeight = self.frame.height - height
        
        let lineHeight = height/CGFloat(lineCount)
        
        let position = CGPoint(x: point.x, y: point.y - spaceHeight/2)
        let lineIndex = Int(position.y / lineHeight)
        
        let clickPoint = CGPoint(x: position.x, y: position.y - (lineHeight + lineSpace) * CGFloat(lineIndex))
        
        if lineIndex < lineCount && lineIndex >= 0 {
            print("totalLines:\(totalLines),lineIndex:\(lineIndex)")
            let cLine = unsafeBitCast(CFArrayGetValueAtIndex(totalLines, lineIndex), to: CTLine.self)
            let clickLine: CTLine = CTLineCreateTruncatedLine(cLine, Double(self.frame.size.width), CTLineTruncationType.end, nil)!
            
            let startIndex = CTLineGetStringIndexForPosition(clickLine, clickPoint)
            print("lineCount:\(lineCount),lineIndex:\(lineIndex),startIndex:\(startIndex)")
            /*
             // get line information
            let cfRange = CTLineGetStringRange(clickLine)
            let lineLocation = cfRange.location
            let lineLength = cfRange.length
            let lineGlyphCount = CTLineGetGlyphCount(clickLine)
            let runs = CTLineGetGlyphRuns(clickLine)
            let runCount = CFArrayGetCount(runs)
            */
            for tagsModel in tagsModelArray{
                if startIndex >= (tagsModel.range?.location)! && startIndex < (tagsModel.range?.location)! + (tagsModel.range?.length)! {
                    result(tagsModel.text!,tagsModel.range!,startIndex)
                    return true
                }
            }
        }
        
        return false
    }
    
    // size for text
    
    func sizeForText(mutableAttrStr: NSMutableAttributedString) -> CGSize {
        
        let paragraphStyle = self.mkParagraphStyle()
        
        // mutable attributed string with mutable paragraph style
        mutableAttrStr.addAttributes([NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle], range: NSMakeRange(0, mutableAttrStr.length))
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        
        // get the frame size of core text
        let restrictSize = CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil)
        return coreTextSize
    }
    
    // create current paragraph style
    func mkParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = textAlignment
        
        return paragraphStyle
    }
    
    // MARK: -
    // MARK: add tap effect
    fileprivate func saveEffectDictionaryWithRange(_ range : NSRange) -> Void {
        tapEffectDictionary = [:]
        
        let subAttribute = self.attributedText?.attributedSubstring(from: range)
        
        _ = tapEffectDictionary?.updateValue(subAttribute!, forKey: NSStringFromRange(range))
    }
    
    // mark if the UILabel frame is small then text can dispaly
    // the tap effect will display with animate
    fileprivate func tapEffectWithStatus(_ status : Bool) -> Void {
        guard tapEffectDictionary != nil else {
            return
        }
        if isTapEffectEnable {
            let attributedString = NSMutableAttributedString.init(attributedString: self.attributedText!)
            let subAttributedString = NSMutableAttributedString.init(attributedString: (tapEffectDictionary?.values.first)!)
            let range = NSRangeFromString(tapEffectDictionary!.keys.first!)
            if status == true {
                subAttributedString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.lightGray, range: NSMakeRange(0, subAttributedString.length))
                attributedString.replaceCharacters(in: range, with: subAttributedString)
            }else {
                attributedString.replaceCharacters(in: range, with: subAttributedString)
            }
            self.attributedText = attributedString
        }
    }
    
    // MARK: -
    // MARK: touch Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapActionEnable == false {
            return
        }
        let touch = touches.first
        
        let point = touch?.location(in: self)
        
        _ = self.mkGetTapFrame(point!, result: { (text, range, index) in
            if tapAction != nil {
                tapAction! (text, range , index)
            }
            
            if (isTapEffectEnable == true && range.location != NSNotFound) {
                self.saveEffectDictionaryWithRange(range)
                self.tapEffectWithStatus(true)
            }
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapActionEnable == true {
            DispatchQueue.main.async {
                self.tapEffectWithStatus(false)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapActionEnable == true {
            DispatchQueue.main.async {
                self.tapEffectWithStatus(false)
            }
        }
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isTapActionEnable == true {
            let result = self.mkGetTapFrame(point, result: { (text, range, index) in
                // reaction here
            })
            if result == true {
                return self
            }
        }
        return super.hitTest(point, with: event)
    }
}

private extension String {
    
    // get NSRange from Range
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),length: utf16.distance(from: from, to: to))
    }
    
    // get Range from NSRange
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    // get string from Range
    func rangeString(from range: Range<String.Index>) -> String {
        return self.substring(with: range)
    }
}
