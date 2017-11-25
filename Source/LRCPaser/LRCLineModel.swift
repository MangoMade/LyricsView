//
//  LRCLineModel.swift
//  LyricsView
//
//  Created by Aqua on 24/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation

public struct LRCLineModel: LyricsLineModelProtocol {
    
    public var beginTime: TimeInterval = 0.0
    public var text = ""
    
    public init() { }
    
    /// Those properties are unused for LRC lyrics
    public var endTime: TimeInterval = 0.0
    public var characters = [String]()
    public var intervals = [Double]()
}
