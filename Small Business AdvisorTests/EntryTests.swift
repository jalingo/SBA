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
        
        mock = MockEntry()
    }
    
    override func tearDown() {

        mock = nil
        
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testCanReadText() { XCTAssertNotNil(mock?.text) }
    
    func testCanReadCategory() { XCTAssertNotNil(mock?.category) }
}

protocol Entry {
    
    var text: String { get }
    
    var category: TipCategory { get }
}

struct MockEntry: Entry {
    
    let text = "TestText"
    
    let category: TipCategory = .planning
}

enum TipCategory {
    case planning, hr
}
