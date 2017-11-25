//
//  LRCPaser.swift
//  LyricsView
//
//  Created by Aqua on 23/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import UIKit

public class LRCPaser: PaserProtocol {
    
    public var content: String
    
    public required init(with content: String) {
        self.content = content
    }
    
    public func generateModel() -> LyricsModel {
        let lineContents = content.components(separatedBy: "\n")
        let models = LyricsModel()
        for line in lineContents {
            if let lineModels = paserLine(line) {
                models.lines.append(contentsOf: lineModels)
            }
        }
        models.lines.sort { (model1, model2) -> Bool in
            return model1.beginTime < model2.beginTime
        }
        return models
    }
    
    private func paserLine(_ text: String) -> [LyricsLineModelProtocol]? {
        
        let pattern =  "^(\\[.*\\])(.*)$"
        let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        guard let result = regExp?.matches(in: text, options: [], range: NSMakeRange(0, text.utf16.count)).first else {
            return nil
        }
        
        let timesRange   = result.range(at: 1)
        let timesString  = (text as NSString).substring(with: timesRange)
        let lyricsRange  = result.range(at: 2)
        let lyricsString = (text as NSString).substring(with: lyricsRange)
        
        if let times = paserTimes(timesString) {
            var lines: [LRCLineModel] = []
            times.forEach({ (time) in
                var model = LRCLineModel()
                model.beginTime = time
                model.text = lyricsString
                lines.append(model)
            })
            return lines
        } else {
            return nil
        }
    }
    
    private func paserTimes(_ timesString: String) -> [TimeInterval]? {
        let pattern = "\\[(.*?)\\]"
        let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        guard let results = regExp?.matches(in: timesString, options: [], range: NSMakeRange(0, timesString.utf16.count)) else {
            return nil
        }
        var times: [TimeInterval] = []
        results.forEach { result in
            let timeRange    = result.range(at: 1)
            let timeString   = (timesString as NSString).substring(with: timeRange)
            times.append(stringToTimeInterval(timeString))
        }
        return times
    }
    
}
