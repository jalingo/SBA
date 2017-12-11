//
//  FlagTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/9/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud

class FlagTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: FlagAbstraction?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = Flag()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Unit Tests
    
    func testFlagHasReason() { XCTAssertNotNil(mock?.reason) }
    
    func testFlagHasAssociatedTip() { XCTAssertNotNil(mock?.tip) }
    
    func testFlagHasCreator() { XCTAssertNotNil(mock?.creator) }
    
    func testFlagIsMCRecordable() { XCTAssert(mock is MCRecordable) }
}
