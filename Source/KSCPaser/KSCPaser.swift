//
//  KSCPaser.swift
//  KSCPaser
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation

public class KSCPaser {
    
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
}
