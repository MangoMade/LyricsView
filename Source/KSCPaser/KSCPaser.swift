//
//  KSCPaser.swift
//  KSCPaser
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation

public class KSCPaser: PaserProtocol {
    
    public var content: String
    
    public required init(with content: String) {
        self.content = content
    }
    
    public func generateModel() -> LyricsModel {
        let lineContents = content.components(separatedBy: "\n")
        let models = LyricsModel()
        for line in lineContents {
            if let lineModel = paserLine(line) {
                models.lines.append(lineModel)
            }
        }
        return models
    }
    
    private func paserLine(_ line: String) -> KSCLineModel? {
        
        let pattern = "^karaoke.add\\('(.*)' *, *'(.*)' *, *'(.*)' *, *'(.*)'\\);$"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let result = regExp.matches(in: line, options: [], range: NSMakeRange(0, line.utf16.count))
        guard result.count != 0 else {
            return nil
        }
        
        let aResult = result[0]
        guard aResult.numberOfRanges == 5 else {
            return nil
        }
        
        var model = KSCLineModel()
        
        for index in 1..<aResult.numberOfRanges {
            let substring = (line as NSString).substring(with: aResult.range(at: index))
            switch index {
            case 1:
                model.beginTime = stringToTimeInterval(substring)
            case 2:
                model.endTime   = stringToTimeInterval(substring)
            case 3:
                model.characters = paserText(substring)
            case 4:
                model.intervals = substring.split(separator: ",").flatMap { (Double($0) ?? 0) / 1000 }
            default:
                break
            }
        }
        return model
    }
    
    private func paserText(_ text: String) -> [String] {
        let pattern = "\\[(.*?)\\]|(.{1})"
        var charaters: [String] = []
        let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let result = regExp?.matches(in: text, options: [], range: NSMakeRange(0, text.utf16.count))
        result?.forEach({ (aResult) in
            if aResult.range(at: 2).length != 0 {
                charaters.append((text as NSString).substring(with: aResult.range(at: 2)))
            } else if aResult.range(at: 1).length != 0 {
                charaters.append((text as NSString).substring(with: aResult.range(at: 1)))
            }
        })
        return charaters
    }
}
