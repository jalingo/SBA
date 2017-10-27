//
//  EntryTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/25/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class EntryTests: XCTestCase {

    // MARK: - Properties
    
    var mock: Entry?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        
        mock = MockEntry(index: 0,
                         category: .planning,
                         text: "TestText")
    }
    
    override func tearDown() {

        mock = nil
        
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testCanReadText()      { XCTAssertNotNil(mock?.text) }
    
    func testCanReadCategory()  { XCTAssertNotNil(mock?.category) }
    
    func testCanReadIndex()     { XCTAssertNotNil(mock?.index) }
    
    func testIndexCantBeZeroOrNegative() {
        XCTAssertFalse(mock!.index < 1)
        
        let newMock = MockEntry(index: -1, category: .planning, text: "A")
        XCTAssertFalse(newMock.index < 1)
        
        let nextMock = MockEntry(index: 0, category: .planning, text: "B")
        XCTAssertFalse(nextMock.index < 1)
    }
}

protocol Entry {
    
    var text: String { get }
    
    var category: TipCategory { get }
    
    var index: Int { get }
}

struct MockEntry: Entry {
    
    let text: String
    
    let category: TipCategory
    
    let index: Int
    
    init(index integer: Int, category cat: TipCategory, text str: String) {
        self.category = cat
        self.text = str
        
        integer > 0 ? self.index = integer : (self.index = 999999)
    }
}
