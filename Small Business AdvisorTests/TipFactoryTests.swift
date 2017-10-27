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
        mock = MockFactory()
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
        XCTAssert(AnyEntry(entry: mock!.produceByRandom()) != AnyEntry(entry: mock!.produceByRandom()))
    }
}

protocol EntryFactory {
    
    func produceByIndex(index: Int) -> Entry
    
    func produceByRandom() -> Entry
}

struct MockFactory: EntryFactory {
    
    func produceByIndex(index integer: Int) -> Entry {
        return MockEntry(index: integer, category: .planning, text: "Test")
    }
    
    func produceByRandom() -> Entry {
        return MockEntry(index: 0, category: .planning, text: "Test")
    }
}
