//
//  TextFactory.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/27/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class TextFactoryTests: XCTestCase {
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        
        super.tearDown()
    }
 
    // MARK: - Functions: Tests
    
    func testStringFactoryHasMax() { XCTAssert(MockTextFactory.max == 105) }    // <-- This will need to switch to a dynamic total.
    
    func testStringFactoryProducesString() { XCTAssert(MockTextFactory.produce(for: 0) is NSAttributedString) }
    
    func testStringFactoryProducesDifferentStrings() {
        let first = MockTextFactory.produce(for: 1)
        let second = MockTextFactory.produce(for: 2)
        
        XCTAssertNotEqual(first, second)
    }
    
    func testStringFactoryIndexesHaveLimitedRange() {
        let belowRange = MockTextFactory.produce(for: -3)
        let aboveRange = MockTextFactory.produce(for: 199)
        
        if let lowBall = Int("\(belowRange)") {
            XCTAssert(lowBall > 0)
        } else {
            XCTFail()
        }
        
        if let hiBall = Int("\(aboveRange)") {
            XCTAssert(hiBall < 106)
        } else {
            XCTFail()
        }
    }    
}

struct MockTextFactory: StringFactory {
    
    static var max = 105   // <-- Eventually these will have to calculate dynamic totals...
    
    static func produce(for index: Int) -> NSAttributedString {

        var str: String
        
        switch index {
        case ..<1:      str = "\(1)"
        case 1..<105:   str = "\(index)"
        default:        str = "\(105)"
        }
        
        return NSAttributedString(string: str)
    }
}
