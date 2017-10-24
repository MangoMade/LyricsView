//
//  KSCModel.swift
//  KSCPaser
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation


public struct KSCLineModel: LyricsLineModelProtocol {
    
    public var beginTime: TimeInterval = 0.0
    public var endTime: TimeInterval = 0.0
    public var characters = [String]() {
        didSet {
            text = characters.reduce("", +)
        }
    }
    public var intervals = [Double]()
    public var text = ""
    
    public init() { }
}
