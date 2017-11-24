//
//  VoteCounterTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/16/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
@testable import MagicCloud
import CloudKit

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
    
    func testVoteCounterHasAllVotes() { XCTAssertNotNil(mock?.allVotes) }
    
    func testCanWriteAllVotes() {
        let votes: [VoteAbstraction] = [MockVote()]
        mock?.allVotes = votes
        XCTAssertEqual(mock!.allVotes as! [MockVote], votes as! [MockVote])
    }
    
    func testVoteReceiverCanTabulateVotes() {
        mock?.allVotes = testVotes()
        
        let tips = testTips()
        if let results = mock?.tabulateResults(for: tips) {
            XCTAssertEqual(results[tips[0]], TipFactory.max - 1)    // <-- This will need to change
        } else {
            XCTFail()
        }
    }
    
    func testVoteCounterCanTallyVotesByTotal() {
        mock?.allVotes = testVotes()
        
        let tips = testTips()
        if let sortedTips = mock?.rank(for: tips) {
            XCTAssertEqual(tips, sortedTips)
            XCTAssertEqual(tips.first, sortedTips.first)
            XCTAssertEqual(tips[3], sortedTips[3])
        } else {
            XCTFail()
        }
    }
    
    func testVoteCounterCanTallyVotesByCategory() {
        mock?.allVotes = testVotes()
        
        let tips = testTips()
        if let sortedTips = mock?.rank(for: tips, by: TipCategory.hr) {
            let validation = tips.filter { $0.category == .hr }
            
            XCTAssertEqual(validation, sortedTips)
            XCTAssertEqual(validation.first, sortedTips.first)
            XCTAssertEqual(validation[5], sortedTips[5])
        } else {
            XCTFail()
        }
    }
}

struct MockVoteCounter: VoteCounter {
    var allVotes = [VoteAbstraction]()
}
