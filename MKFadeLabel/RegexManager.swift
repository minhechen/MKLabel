//
//  RegexManager.swift
//  MKFadeLabel
//
//  Created by AC-Mac on 06/12/2017.
//  Copyright © 2017 MackChan  minhechen@gmail.com. All rights reserved.
//

import UIKit

class RegexManager: NSObject {

    static let shared: RegexManager = RegexManager()
    /*
    init(_ pattern:String)
    {
        super.init()
        do {
            try regex = NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            
        }
    }
    */
    /* get regex matchs result
     * -parameter input: the string to be matched
     * -parameter pattern: the pattern string
     * retrun [NSTextCheckingResult] array
    */
    func match(input:String, pattern: String = "") -> [NSTextCheckingResult]
    {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: input, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, input.characters.count))
            if  matches.count > 0 {
                return matches
            }else{
                return []
            }
        } catch {
            
        }
        return []
    }
}
