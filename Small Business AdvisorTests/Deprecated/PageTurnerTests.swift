////
////  AdvisorVCTests.swift
////  Small Business AdvisorTests
////
////  Created by James Lingo on 11/1/17.
////  Copyright © 2017 Escape Chaos. All rights reserved.
////
//
//import XCTest
//
//class PageTurnerTests: XCTestCase {
//    
//    // MARK: - Properties
//    
//    var mock: PageTurner?
//    
//    // MARK: - Functions
//    
//    override func setUp() {
//        super.setUp()
//        mock = MockPageTurner()
//    }
//    
//    override func tearDown() {
//        mock = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Functions: Tests
//    
//    func testAdvisorRecieverHasPage() { XCTAssertNotNil(mock?.page) }
//    
//    func testPageIsReadWrite() {
//        let test = 3
//        mock?.page = test
//        XCTAssertEqual(test, mock?.page)
//    }
//    
//    func testAdvisorHasResponse() { XCTAssertNotNil(mock?.response) }
//}
//
//class MockPageTurner: UIViewController, PageTurner {
//    
//    var response = ResponseText()
//    
//    var page = 0
//
//}

