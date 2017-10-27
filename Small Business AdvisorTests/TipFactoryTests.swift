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
        
        let test3 = MockTipFactory.produceByIndex(index: 24)
        test3.category == .outOfRange ? XCTFail() : XCTAssert(test3.category == TipCategory.organization)
        
        let test9 = MockTipFactory.produceByIndex(index: 9)
        test9.category == .outOfRange ? XCTFail() : XCTAssert(test9.category == TipCategory.planning)

    }
    
    func testEntryFactoryHasMaxCount() {
        XCTAssertNotNil(MockTipFactory.max)
    }
}

protocol EntryFactory {

    static var max: Int { get }
    
    static func produceByIndex(index: Int) -> Entry
    
    static func produceByRandom() -> Entry
}

struct MockTipFactory: EntryFactory {
    
    static let max = 16

    static func produceByIndex(index integer: Int) -> Entry {
        return MockTip(index: integer, category: TipCategoryFactory.produceByIndex(index: integer), text: "Test")
    }
    
    static func produceByRandom() -> Entry {
        let random = Int(arc4random_uniform(UInt32(self.max)))
        return MockTip(index: random, category: TipCategoryFactory.produceByIndex(index: random), text: "Test")
    }
}
