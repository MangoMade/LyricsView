//
//  KSCModel.swift
//  KSCPaser
//
//  Created by Aqua on 20/10/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import Foundation


struct KSCLineModel: LyricsLineModelProtocol {
    
    var beginTime = ""
    var endTime   = ""
    var text      = ""
    var intervals = [Double]()

}
