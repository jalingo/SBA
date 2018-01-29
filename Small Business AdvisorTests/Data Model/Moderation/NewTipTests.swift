//
//  NewTipTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud
import CloudKit

class NewTipTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: NewTipAbstraction?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = NewTip(text: "blah", category: "blah")
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Unit Tests
    
    func testNewTipHasText() { XCTAssertNotNil(mock?.text) }
    
    func testNewTipHasCategory() { XCTAssertNotNil(mock?.category) }
    
    func testNewTipIsMCRecordable() { XCTAssert(mock is MCRecordable) }
}
