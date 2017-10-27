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
    
    var mock: EntryFactory?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        mock = MockTipFactory()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }

    // MARK: - Functions: Tests
    
    func testEntryFactoryProducesEntry() { XCTAssertNotNil(mock?.produceByIndex(index: 1)) }
    
    func testEntryFactoryProducesByIndex() {
        XCTAssert(mock?.produceByIndex(index: 1).index == 1)
        XCTAssert(mock?.produceByIndex(index: 5).index == 5)
        XCTAssert(mock?.produceByIndex(index: 9).index == 9)
    }
    
    func testEntryFactoryProducesByRandom() {
        XCTAssertNotNil(mock?.produceByRandom())
        XCTAssertFalse(AnyEntry(entry: mock!.produceByRandom()) == AnyEntry(entry: mock!.produceByRandom()))
    }
    
    func testEntryFactoryHasMaxCount() {
        XCTAssertNotNil(mock?.Max)
    }
    
//    func testEntryFactoryHasCategoryFactory() {
//        XCTAssertNotNil(mock?.CategoryFactory)
//    }
}

protocol EntryFactory {

    var Max: Int { get }
    
    func produceByIndex(index: Int) -> Entry
    
    func produceByRandom() -> Entry
}

struct MockTipFactory: EntryFactory {
    
    let Max = 16

    func produceByIndex(index integer: Int) -> Entry {
        return MockTip(index: integer, category: .planning, text: "Test")
    }
    
    func produceByRandom() -> Entry {
        return MockTip(index: Int(arc4random_uniform(UInt32(self.Max))), category: .planning, text: "Test")
    }
}
