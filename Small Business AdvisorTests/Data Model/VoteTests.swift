//
//  VoteTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/17/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud

class VoteTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: VoteAbstraction?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        mock = MockVote()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testVoteAbstractionIsReceivesRecordable() { XCTAssert(mock is Recordable) }
    
}

protocol VoteAbstraction {
    
}

struct MockVote: VoteAbstraction {
    
}
