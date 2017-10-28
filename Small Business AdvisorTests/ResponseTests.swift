//
//  ResponseTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/28/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class ResponseTests: XCTestCase {

    // MARK: - Properties
    
    var mock: ResponseAggregator?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        mock = MockResponse()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testResponseCanOutputByRandom() { XCTAssertNotNil(mock?.byRandom()) }
    
    func testResponseByRandomWorks() {
        
    }
    
    func testResponseCanOutputByIndex() { XCTAssertNotNil(mock?.byIndex(of: 0)) }
    
    func testResponseByIndexWorks() {
        
    }
}

protocol ResponseAggregator {
    
    func byRandom() -> NSAttributedString
    
    func byIndex(of: Int) -> NSAttributedString
}

struct MockResponse: ResponseAggregator {
    
    func byRandom() -> NSAttributedString {
        let random = TipFactory.produceByRandom()
        
        let category = random.category
        
        return NSAttributedString()
    }
    
    func byIndex(of: Int) -> NSAttributedString {
        return NSAttributedString()
    }
}
