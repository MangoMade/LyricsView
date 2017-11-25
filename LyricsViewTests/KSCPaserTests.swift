//
//  KSCPaserTests.swift
//  LyricsViewTests
//
//  Created by Aqua on 25/11/2017.
//  Copyright © 2017 Aqua. All rights reserved.
//

import XCTest
@testable import LyricsView

class KSCPaserTests: PaserBaseTestCase {
    
    private var model: LyricsModel!
    
    override func setUp() {
        super.setUp()

        let content = "karaoke.add('00:03.197','00:06.612','蔡健雅[-beautiful ][love]','691,768,579,583,794');\n" +
                      "karaoke.add('00:24.481','00:29.412','看住时间别让它再流浪','186,233,549,1136,486,226,368,589,650,508');\n" +
                      "karaoke.add('02:43.750','02:46.596','[love ][is ][beautiful]','266,323,2257');\n" +
                      "karaoke.add('02:43.750','02:46.596','[love ][is ][beautiful]','266');\n"
        let paser = KSCPaser(with: content)
        model = paser.generateModel()
    }
    
    func testTimes() {
        
        let line1  = model.lines[0]
        let line2 = model.lines[2]
        
        XCTAssert(line1.beginTime.isEqualByThreeDecimal(to: 3.197))
        XCTAssert(line1.endTime.isEqualByThreeDecimal(to: 6.612))
        XCTAssert(line2.beginTime.isEqualByThreeDecimal(to: 163.75))
        XCTAssert(line2.endTime.isEqualByThreeDecimal(to: 166.596))
    }
    
    func testTexts() {
        
        let line1 = model.lines[0]
        let line2 = model.lines[1]
        let line3 = model.lines[2]
        
        XCTAssert(line1.text == "蔡健雅-beautiful love")
        XCTAssert(line2.text == "看住时间别让它再流浪")
        XCTAssert(line3.text == "love is beautiful")
        
        XCTAssert(line1.characters == ["蔡", "健", "雅" ,"-beautiful ", "love"])
        XCTAssert(line2.characters == ["看", "住", "时", "间", "别", "让", "它", "再", "流", "浪"])
        XCTAssert(line3.characters == ["love ", "is ", "beautiful"])
    }
    
    func testTimeIntervals() {
        let line1 = model.lines[1]
        let line2 = model.lines[3]
        
        XCTAssert(line1.intervals.count == 10)
        XCTAssert(line1.intervals[0].isEqualByThreeDecimal(to: 0.186))
        
        XCTAssert(line2.intervals.count == 1)
        XCTAssert(line2.intervals[0].isEqualByThreeDecimal(to: 0.266))
    }
    
    func testLineCount() {
        
        XCTAssert(model.lines.count == 4, "Current count is \(model.lines.count)")
    }
}
