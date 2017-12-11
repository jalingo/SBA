//
//  EditTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud
import CloudKit

class EditTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: EditAbstraction?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = TipEdit()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Unit Tests
    
    func testEditHasNewText() { XCTAssertNotNil(mock?.newText) }
    
    func testEditHasNewCategory() { XCTAssertNotNil(mock?.newCategory) }
    
    func testEditHasTipReference() { XCTAssertNotNil(mock?.tip) }
    
    func testEditIsMCRecordable() { XCTAssert(mock is MCRecordable) }
}
