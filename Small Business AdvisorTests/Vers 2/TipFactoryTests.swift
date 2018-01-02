//
//  _TipFactoryTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud
import CloudKit

class _TipFactoryTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: _TipFactoryAbstraction?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = TipFactory(db: .publicDB)
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Unit Tests
    
    func testTipFactoryHasCount() { XCTAssertNotNil(mock?.count) }
    
    func testTipFactoryCanProduceByRank() { XCTAssertNotNil(mock?.rank(of: 1)) }
    
    func testTipFactoryRankStaysInRangeRange() {
        let belowMin = 0
        let aboveMax = mock!.count + 1

        // This tests that when a rank below 1 is attempted, first is returned instead.
        if let outOfLowerRangeTip = mock?.rank(of: belowMin), let lowestTipInRange = mock?.rank(of: 1) {
            XCTAssert(outOfLowerRangeTip.recordID.recordName == lowestTipInRange.recordID.recordName)
        } else {
            XCTFail()
        }
        
        // This tests that when a rank above the last rank is attempted, last is returned instead.
        if let outOfUpperRangeTip = mock?.rank(of: aboveMax), let highestTipInRange = mock?.rank(of: mock!.count) {
            XCTAssert(outOfUpperRangeTip.recordID.recordName == highestTipInRange.recordID.recordName)
        } else {
            XCTFail()
        }
    }
    
    func testTipFactoryCanProduceByRandom() { XCTAssertNotNil(mock?.random()) }
    
    func testTipFactoryHasLastRank() { XCTAssertNotNil(mock?.lastRank) }
    
    func testTipFactoryHasCategoryLimitation() {
        mock?.limitation = TipCategory.hr
        XCTAssertNotNil(mock?.limitation)
        
        mock?.limitation = TipCategory.efficiency
        let topInEfficiency = mock?.rank(of: 1)
        
        mock?.limitation = TipCategory.fiscal
        let topInFiscal = mock?.rank(of: 1)
        
        mock?.limitation = nil
        let topAllCategories = mock?.rank(of: 1)
        
        XCTAssertFalse(topInFiscal == topInEfficiency)
        XCTAssertFalse(topAllCategories == topInEfficiency && topInFiscal == topAllCategories)
    }
}
