//
//  LRCPaser.swift
//  LyricsView
//
//  Created by Aqua on 23/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

class LRCPaser {
    
    private var content: String
    
    public init(with content: String) {
        self.content = content
    }
    
    public func generateModel() -> LyricsModel {
        let lineContents = content.components(separatedBy: "\n")
        let models = LyricsModel()
        for line in lineContents {
            if let lineModel = KSCGrammerPaser.paser(line: line) {
                models.lines.append(lineModel)
            }
        }
        return models
    }
    
    
    private func paserLine(_ text: String) -> (times: [TimeInterval], lyrics: String)? {
        
        let pattern =  "^(\\[.*\\])(.*)$"
        let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        guard let result = regExp?.matches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)) else {
            return nil
        }
        
        if result.count > 0 {
            
        }
        
        return ([], "")
    }
}
