//
//  AnyPickerTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/12/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import UIKit
import MagicCloud

class AnyPickerTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: AnyPicker<Tip>?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = AnyPicker()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }

    // MARK: - Functions: Unit Tests
    
//    func testAnyPickerHasType() { XCTAssertNotNil(mock) }   // <-- Dependency injected in setUp()
    
    func testAnyPickerHasReceiver() { XCTAssertNotNil(mock?.receiver) }
    
    func testAnyPickerHasSelectionFollowUp() { XCTAssertNotNil(mock?.selectionFollowUp) }
    
    func testAnyPickerHasView() { XCTAssertNotNil(mock?.view) }
    
    func testAnyPickerIsPickerDelegateAndDataSource() {
        XCTAssert(mock is UIPickerViewDelegate)
        XCTAssert(mock is UIPickerViewDataSource)
    }
    
}
