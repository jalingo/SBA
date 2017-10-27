//
//  CategoryFactoryTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/27/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class TipCategoryFactoryTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: CategoryFactory?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        mock = MockTipCategoryFactory()
        
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testTipCategoryFactoryProducesByIndex() {
        XCTAssertNotNil(mock?.produceByIndex(index: 0))
    }
    
    func testTipCategoryOnlyAcceptsRecognizesOutOfRange() {
        XCTAssert(mock?.produceByIndex(index: TipCategory.Max + 1) == TipCategory.outOfRange)
    }
}

struct MockTipCategoryFactory: CategoryFactory {
    func produceByIndex(index: Int) -> TipCategory { return TipCategory(rawValue: index) ?? .outOfRange }
}
