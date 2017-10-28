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

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    
}

protocol ResponseAggregator {
    
    func byRandom() -> NSAttributedString
    
    func byIndex(of: Int) -> NSAttributedString
}

struct MockResponse: ResponseAggregator {
    
    func byRandom() -> NSAttributedString {
        let random = TipFactory.produceByRandom()
        
        return NSAttributedString()
    }
    
    func byIndex(of: Int) -> NSAttributedString {
        return NSAttributedString()
    }
}
