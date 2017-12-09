//
//  FlagTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/9/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud
import CloudKit

class FlagTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: Flag?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
//        mock =
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Unit Tests
    
    func testFlagHasReason() { XCTAssertNotNil(mock?.reason) }
    
    func testFlagHasAssociatedTip() { XCTAssertNotNil(mock?.tip) }
    
    func testFlagTracksCreator() {
        if let currentUser = MCUserRecord().singleton {
            let tip = Tip(index: -1, category: .outOfRange, text: NSAttributedString(string: "Test_Text"))
            
//            let tipReceiver =
            
        } else {
            XCTFail()
        }
    }
}

enum FlagReason {
    case offTopic, inaccurate, duplicate(Tip), wrongCategory(TipCategory), spam, abusive
}

protocol Flag {
    var reason: FlagReason { get set }
    var tip: CKReference { get set }
}
