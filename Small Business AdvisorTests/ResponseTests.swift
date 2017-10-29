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
    
    // This uses a triple random comparison, which may on occassion fail through odds fulfillment (or luck 🤡).
    func testResponseByRandomWorks() {
        guard let firstRandom = mock?.byRandom() else { XCTFail(); return }
        guard let secondRandom = mock?.byRandom() else { XCTFail(); return }
        guard let thirdRandom = mock?.byRandom() else { XCTFail(); return }
        
        XCTAssertNotEqual(firstRandom, secondRandom)
        XCTAssertNotEqual(firstRandom, thirdRandom)
        XCTAssertNotEqual(secondRandom, thirdRandom)
    }
    
    func testResponseCanOutputByIndex() { XCTAssertNotNil(mock?.byIndex(of: 0)) }
    
    func testResponseByIndexWorks() {
        
        for index in 1...105 {
            let validationBody = TextFactory.produce(for: index)
            let validationTitle = TipCategoryFactory.produceByIndex(index: index).bold

            let validation = "\(validationTitle)\n\n\(validationBody)"
            XCTAssert(mock?.byIndex(of: index) == NSAttributedString(string: validation), "Failed @:\(index)")
        }
    }
    
    func testResponseStoresLastIndex() {
        let testResult = mock?.byRandom()
        
        if let index = mock?.lastIndex {
            XCTAssertEqual(testResult, mock?.byIndex(of: index))
        } else {
            XCTFail()
        }
    }
}

struct MockResponse: ResponseAggregator {
    
    var _lastIndex = 0
    
    var lastIndex: Int { return _lastIndex }
    
    mutating func byRandom() -> NSAttributedString {
        let random = TipFactory.produceByRandom()
        
        _lastIndex = random.index
        let category = random.category.bold
        let text = random.text
        
        return NSAttributedString(string: "\(category)\n\n\(text)")
    }
    
    mutating func byIndex(of index: Int) -> NSAttributedString {
        
        _lastIndex = index
        let category = TipCategoryFactory.produceByIndex(index: index).bold
        let text = TextFactory.produce(for: index)

        return NSAttributedString(string: "\(category)\n\n\(text)")
    }
}
