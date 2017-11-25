//
//  PaserBaseTestCase.swift
//  LyricsViewTests
//
//  Created by Aqua on 24/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import XCTest

class PaserBaseTestCase: XCTestCase {
    

}

extension Double {
    
    func isEqualByTwoDecimal(to other: Double) -> Bool {
        return abs(self - other) < 0.01
    }
}
