//
//  EntryTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/25/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud

class TipTests: XCTestCase {

    // MARK: - Properties
    
    var mock: Entry?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        
        mock = MockTip(index: 0,
                       category: .planning,
                       text: NSAttributedString(string: "TestText"))
    }
    
    override func tearDown() {

        mock = nil
        
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testCanReadText()      { XCTAssertNotNil(mock?.text) }
    
    func testCanWriteText()     {
        let test: NSAttributedString = NSAttributedString(string: "TEST")
        mock?.text = test
        XCTAssertEqual(test, mock?.text)
    }
    
    func testCanReadCategory()  { XCTAssertNotNil(mock?.category) }
    
    func testCanWriteCategory() {
        let test: TipCategory = .outOfRange
        mock?.category = test
        XCTAssertEqual(test, mock?.category)
    }
    
    func testCanReadIndex()     { XCTAssertNotNil(mock?.index) }
    
    func testCanWriteIndex()    {
        let test = -1
        mock?.index = test
        XCTAssertEqual(test, mock?.index)
    }
    
    func testIndexCantBeZeroOrNegative() {
        XCTAssertFalse(mock!.index < 1)
        
        let newMock = MockTip(index: -1, category: .planning, text: NSAttributedString(string: "A"))
        XCTAssertFalse(newMock.index < 1)
        
        let nextMock = MockTip(index: 0, category: .planning, text: NSAttributedString(string: "B"))
        XCTAssertFalse(nextMock.index < 1)
    }
    
    func testTipIsEquatable()   { XCTAssert(mock is Equatable) }

    func testTipIsHashable()    { XCTAssert(mock is Hashable) }
    
//    func testIsRecordable() { XCTAssert(mock is Recordable) }     // <-- Vers .3
}

struct MockTip: Entry {
    
    var text: NSAttributedString
    
    var category: TipCategory
    
    var index: Int
    
    init(index integer: Int, category cat: TipCategory, text str: NSAttributedString) {
        self.category = cat
        self.text = str
        
        integer > 0 ? (self.index = integer) : (self.index = 999999)
    }
}

extension MockTip: Equatable {
    static func ==(left: MockTip, right: MockTip) -> Bool { return left.index == right.index }
}


