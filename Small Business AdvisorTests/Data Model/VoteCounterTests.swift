//
//  VoteCounterTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/16/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class VoteCounterTests: XCTestCase {

    // MARK: - Properties
    
    var mock: VoteCounter?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        mock = MockVoteCounter()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }

    // MARK: - Functions: Tests
    
    func testVoteCounterHasAllVotes() {
        XCTFail()
    }
    
    func testVoteCounterCanReturnSortedAdvice() {
        XCTFail()
    }
    
    func testVoteCounterInjectsDependencies() {
        XCTFail()
    }
    
    func testVoteCounterCanTallyVotesByCategory() {
        XCTFail()
    }
    
    func testVoteCounterCanTallyVotesByTotal() {
        XCTFail()
    }
}

protocol VoteCounter {
    
}

struct MockVoteCounter: VoteCounter {
    
}
