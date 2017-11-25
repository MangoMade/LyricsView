//
//  PaserProtocol.swift
//  LyricsView
//
//  Created by Aqua on 24/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation

public protocol PaserProtocol {
    
    var content: String { set get }
    
    init(with content: String)
    
    func generateModel() -> LyricsModel
    
}

extension PaserProtocol {
    
    func stringToTimeInterval(_ string: String) -> TimeInterval {
        
        let substings = string.split(separator: ":")
        if substings.count == 2 {
            let min = TimeInterval(substings[0]) ?? 0
            let sec = TimeInterval(substings[1]) ?? 0
            return min * 60 + sec
        } else {
            return 0
        }
    }
}
