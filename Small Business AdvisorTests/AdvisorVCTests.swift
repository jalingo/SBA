//
//  AdvisorVCTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 11/1/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class AdvisorVCTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: AdviceReciever?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        mock = MockAdvisor()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testAdvisorRecieverHasPage() { XCTAssertNotNil(mock?.page) }
    
    func testPageIsReadWrite() {
        let test = 3
        mock?.page = test
        XCTAssertEqual(test, mock?.page)
    }
}

protocol AdviceReciever {
    
    
    var page: Int { get set }
}

class MockAdvisor: UIViewController, AdviceReciever {
    
    var page = 0
    
    
}
