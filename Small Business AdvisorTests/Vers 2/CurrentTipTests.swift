//
//  CurrentTipTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/9/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class CurrentTipTests: XCTestCase {
    
    // MARK: - Properties

    let testIndex = 1

    var mock: CurrentTip?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = MockCurrentTip()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testCurrentTipCanProvideCategory() {
        XCTAssertNotNil(mock?.category(for: testIndex))
        XCTAssertEqual(mock?.category(for: testIndex),
                       TipCategoryFactory.produceByIndex(index: testIndex).formatted)
    }
    
    func testCurrentTipCanProvideText() {
        XCTAssertNotNil(mock?.text(for: testIndex))
        XCTAssertEqual(mock?.text(for: testIndex), TextFactory.produce(for: testIndex))
    }
    
    func testCurrentTipCanProvideRank() {
        
    }
}

protocol CurrentTip {
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    func category(for index: Int) -> NSAttributedString
    
    func text(for index: Int) -> NSAttributedString
}

struct MockCurrentTip: CurrentTip {
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    func category(for index: Int) -> NSAttributedString {
        return TipCategoryFactory.produceByIndex(index: index).formatted
    }
    
    func text(for index: Int) -> NSAttributedString {
        return TextFactory.produce(for: index)
    }
}
