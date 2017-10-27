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
    
//    var mock: EntryFactory?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
//        mock = MockTipFactory()
    }
    
    override func tearDown() {
//        mock = nil
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
        
        let test3 = MockTipFactory.produceByIndex(index: 3)
        test3.category == .outOfRange ? XCTFail() : XCTAssert(test3.category == TipCategoryFactory.produceByIndex(index: 3))
        
        let test9 = MockTipFactory.produceByIndex(index: 9)
        test9.category == .outOfRange ? XCTFail() : XCTAssert(test9.category == TipCategoryFactory.produceByIndex(index: 9))

    }
    
    func testEntryFactoryHasMaxCount() {
        XCTAssertNotNil(MockTipFactory.Max)
    }
}

protocol EntryFactory {

    static var Max: Int { get }
    
    static func produceByIndex(index: Int) -> Entry
    
    static func produceByRandom() -> Entry
}

struct MockTipFactory: EntryFactory {
    
    static let Max = 16

    static func produceByIndex(index integer: Int) -> Entry {
        return MockTip(index: integer, category: .outOfRange, text: "Test")
    }
    
    static func produceByRandom() -> Entry {
        return MockTip(index: Int(arc4random_uniform(UInt32(self.Max))), category: .outOfRange, text: "Test")
    }
}
