//
//  LyricsProtocol.swift
//  KSCPaser
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation

public protocol LyricsModelProtocol {
    
    var lines: [LyricsLineModelProtocol] { get }
}

public class LyricsModel: LyricsModelProtocol {
    
    public var lines: [LyricsLineModelProtocol] = []
}

public protocol LyricsLineModelProtocol {
    
    var beginTime: TimeInterval { get }
    var endTime: TimeInterval   { get }
    var text: String            { get }
    var intervals: [Double]     { get }
    
}
