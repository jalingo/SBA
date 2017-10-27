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

// Extension that provides tools for AnyEntry wrapper.
extension Entry where Self: Equatable {
    
    func isEqualTo(entry: Entry) -> Bool {
        guard let other = entry as? Self else { return false }
        return self == other
    }
    
    func equatableVersion() -> AnyEntry { return AnyEntry(entry: self) }
}

// Wrapper whose purpose is Equatable conformance.
struct AnyEntry: Entry, Equatable {
    
    let wrappedEntry: Entry
    
    var text: String { return wrappedEntry.text }
    
    var category: TipCategory { return wrappedEntry.category }
    
    var index: Int { return wrappedEntry.index }
    
    static func ==(lhs: AnyEntry, rhs: AnyEntry) -> Bool { return lhs.index == rhs.index }

    func asEntry() -> Entry { return wrappedEntry }
    
    init(entry: Entry) { wrappedEntry = entry }
}

struct MockEntry: Entry, Equatable {
    
    let text: String
    
    let category: TipCategory
    
    let index: Int
    
    static func ==(left: MockEntry, right: MockEntry) -> Bool { return left.index == right.index }

    init(index integer: Int, category cat: TipCategory, text str: String) {
        self.category = cat
        self.text = str
        
        integer > 0 ? self.index = integer : (self.index = 999999)
    }
}


