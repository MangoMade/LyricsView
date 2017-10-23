//
//  KSCGrammerPaser.swift
//  KSCPaser
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

struct KSCGrammerPaser {
    
    static func paserLine(_ string: String) -> KSCLineModel? {
        
        let pattern = "^karaoke.add\\('(.*)' *, *'(.*)' *, *'(.*)' *, *'(.*)'\\);$"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let result = regExp.matches(in: string, options: [], range: NSMakeRange(0, string.utf16.count))
        guard result.count != 0 else {
            return nil
        }
        
        let aResult = result[0]
        guard aResult.numberOfRanges == 5 else {
            return nil
        }
        
        var model = KSCLineModel()
    
        for index in 1..<aResult.numberOfRanges {
            let substring = (string as NSString).substring(with: aResult.range(at: index))
            switch index {
            case 1:
                model.beginTime = substring
            case 2:
                model.endTime   = substring
            case 3:
                model.text      = substring
            case 4:
                model.intervals = substring.split(separator: ",").flatMap { Double($0) }
            default:
                break
            }
        }
        return model
    }
}
