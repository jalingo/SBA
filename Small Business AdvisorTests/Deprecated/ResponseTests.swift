////
////  ResponseTests.swift
////  Small Business AdvisorTests
////
////  Created by James Lingo on 10/28/17.
////  Copyright © 2017 Escape Chaos. All rights reserved.
////
//
//import XCTest
//
//class ResponseTests: XCTestCase {
//
//    // MARK: - Properties
//    
//    var mock: ResponseAggregator?
//    
//    // MARK: - Functions
//    
//    override func setUp() {
//        super.setUp()
//        mock = ResponseText()
//    }
//    
//    override func tearDown() {
//        mock = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Functions: Tests
//    
//    func testResponseCanOutputByRandom() { XCTAssertNotNil(mock?.byRandom()) }
//    
//    // This uses a triple random comparison, which may on occassion fail through odds fulfillment (or luck 🤡).
//    func testResponseByRandomWorks() {
//        guard let firstRandom = mock?.byRandom() else { XCTFail(); return }
//        guard let secondRandom = mock?.byRandom() else { XCTFail(); return }
//        guard let thirdRandom = mock?.byRandom() else { XCTFail(); return }
//        
//        XCTAssertNotEqual(firstRandom, secondRandom)
//        XCTAssertNotEqual(firstRandom, thirdRandom)
//        XCTAssertNotEqual(secondRandom, thirdRandom)
//    }
//    
//    func testResponseCanOutputByIndex() { XCTAssertNotNil(mock?.byIndex(of: 0)) }
//    
//    func testResponseByIndexWorks() {
//        
//        for index in 1...105 {
//            let validation = TipCategoryFactory.produceByIndex(index: index).formatted
//
//            let validationBody = TextFactory.produce(for: index)
//            validation.append(NSAttributedString(string: "\n\n"))
//            validation.append(validationBody)
//
//            XCTAssert(mock?.byIndex(of: index) == validation, "Failed @:\(index)")
//        }
//    }
//    
//    func testResponseStoresLastIndex() {
//        let testResult = mock?.byRandom()
//        
//        if let index = mock?.lastIndex {
//            XCTAssertEqual(testResult, mock?.byIndex(of: index))
//        } else {
//            XCTFail()
//        }
//    }
//}

