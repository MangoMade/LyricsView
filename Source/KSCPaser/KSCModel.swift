//
//  KSCModel.swift
//  KSCPaser
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation


struct KSCLineModel: LyricsLineModelProtocol {
    
    var beginTime: TimeInterval = 0.0
    var endTime: TimeInterval = 0.0
    var text      = ""
    var intervals = [Double]()

}
