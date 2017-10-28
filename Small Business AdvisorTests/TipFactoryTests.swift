//
//  TipFactoryTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/26/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class TipFactoryTests: XCTestCase {
  
    // MARK: - Properties
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {

        super.tearDown()
    }

    // MARK: - Functions: Tests
    
    func testEntryFactoryProducesEntry() { XCTAssertNotNil(MockTipFactory.produceByIndex(index: 1)) }
    
    func testEntryFactoryProducesByIndex() {
        XCTAssert(MockTipFactory.produceByIndex(index: 1).index == 1)
        XCTAssert(MockTipFactory.produceByIndex(index: 5).index == 5)
        XCTAssert(MockTipFactory.produceByIndex(index: 9).index == 9)
    }
    
    func testEntryFactoryProducesByRandom() {
        XCTAssertFalse(AnyEntry(entry: MockTipFactory.produceByRandom()) == AnyEntry(entry: MockTipFactory.produceByRandom()))
    }
    
    func testEntryFactoryProducesEntriesWithCorrectCategory() {
        let random = MockTipFactory.produceByRandom()
        random.category == .outOfRange ? XCTFail() :
            XCTAssert(random.category == TipCategoryFactory.produceByIndex(index: random.index))
        
        let test9 = MockTipFactory.produceByIndex(index: 9)
        test9.category == .outOfRange ? XCTFail() : XCTAssert(test9.category == .planning)
        
        let test24 = MockTipFactory.produceByIndex(index: 24)
        test24.category == .outOfRange ? XCTFail() : XCTAssert(test24.category == .organization)
        
        let test30 = MockTipFactory.produceByIndex(index: 30)
        test30.category == .outOfRange ? XCTFail() : XCTAssert(test30.category == .marketing)
        
        let test46 = MockTipFactory.produceByIndex(index: 46)
        test46.category == .outOfRange ? XCTFail() : XCTAssert(test46.category == .operations)
        
        let test51 = MockTipFactory.produceByIndex(index: 51)
        test51.category == .outOfRange ? XCTFail() : XCTAssert(test51.category == .technology)
        
        let test62 = MockTipFactory.produceByIndex(index: 62)
        test62.category == .outOfRange ? XCTFail() : XCTAssert(test62.category == .value)
        
        let test66 = MockTipFactory.produceByIndex(index: 66)
        test66.category == .outOfRange ? XCTFail() : XCTAssert(test66.category == .efficiency)
        
        let test71 = MockTipFactory.produceByIndex(index: 71)
        test71.category == .outOfRange ? XCTFail() : XCTAssert(test71.category == .fiscal)
        
        let test90 = MockTipFactory.produceByIndex(index: 90)
        test90.category == .outOfRange ? XCTFail() : XCTAssert(test90.category == .hr)
        
        let test96 = MockTipFactory.produceByIndex(index: 96)
        test96.category == .outOfRange ? XCTFail() : XCTAssert(test96.category == .security)
        
        let test00 = MockTipFactory.produceByIndex(index: 100)
        test00.category == .outOfRange ? XCTFail() : XCTAssert(test00.category == .legal)
    }
    
    func testEntryFactoryHasMaxCount() {
        XCTAssertNotNil(MockTipFactory.max)
    }
}

struct MockTipFactory: EntryFactory {
    
    static let max = 105

    static func produceByIndex(index integer: Int) -> Entry {
        return MockTip(index: integer, category: TipCategoryFactory.produceByIndex(index: integer), text: "Test")
    }
    
    static func produceByRandom() -> Entry {
        let random = Int(arc4random_uniform(UInt32(self.max)))
        return MockTip(index: random, category: TipCategoryFactory.produceByIndex(index: random), text: "Test")
    }
}
