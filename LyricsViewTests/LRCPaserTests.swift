//
//  LRCPaserTests.swift
//  LyricsViewTests
//
//  Created by Aqua on 24/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import XCTest
@testable import LyricsView

class LRCPaserTests: PaserBaseTestCase {
    
    private var model: LyricsModel!
    
    override func setUp() {
        super.setUp()
        let content = "[00:00.86]Beautiful Love\n" +
        "[01:18.77][01:45.49][02:43.88][03:37.35][04:03.89][04:33.68]love is beautiful\n" +
        "[01:22.06]so beautiful\n"
        let paser = LRCPaser(with: content)
        model = paser.generateModel()
    }
    
    func testSingleTimeLine() {
        
        let line1  = model.lines[0]
        let line2 = model.lines[2]

        XCTAssert(line1.beginTime.isEqualByThreeDecimal(to: 0.86))
        XCTAssert(line1.text == "Beautiful Love")
        XCTAssert(line2.beginTime.isEqualByThreeDecimal(to: 82.06))
        XCTAssert(line2.text == "so beautiful")
    }
    
    func testMultipleTimeLine() {
        
        let line1 = model.lines[1]
        let line2 = model.lines[3]
        let text = "love is beautiful"
        
        XCTAssert(line1.beginTime.isEqualByThreeDecimal(to: 78.77))
        XCTAssert(line1.text == text)
        XCTAssert(line2.beginTime.isEqualByThreeDecimal(to: 105.49))
        XCTAssert(line2.text == text)
    }
    
    func testLineCount() {
        
        XCTAssert(model.lines.count == 8, "Current count is \(model.lines.count)")
    }
}
