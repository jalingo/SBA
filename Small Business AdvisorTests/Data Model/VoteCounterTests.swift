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
        mock = MockVoteCounter(ballots: [MockVote]())
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
    
    func testVoteCounterInjectsDependencies() {
        let dependecy = [VoteAbstraction]()
        mock = MockVoteCounter(ballots: dependecy)
        XCTAssertEqual(dependecy.count, mock?.allVotes.count)
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

protocol VoteCounter {
    
    // !!
    var allVotes: [VoteAbstraction] { get set }
    
    // !!
    func tabulateResults(for: [Tip]) -> [Tip: Int]

    // !!
    func rank(for: [Tip], by: TipCategory?) -> [Tip]
}

extension VoteCounter {
    
    // MARK: - Functions
    
    fileprivate func sort(_ dictionary: [Tip: Int], by category: TipCategory) -> [Tip] {
        return dictionary.keys.filter({ $0.category == category }).sorted { $0.score > $1.score }
    }
    
    fileprivate func sortBy(rank dictionary: [Tip: Int]) -> [Tip] {
        return dictionary.keys.sorted() { $0.score > $1.score }
    }
    
    // MARK: - Functions: VoteCounter
    
    func rank(for tips: [Tip], by category: TipCategory? = nil) -> [Tip] {
        let result = tabulateResults(for: tips)
        if let category = category {
            return sort(result, by: category)
        } else {
            return sortBy(rank: result)
        }
    }
    
    func tabulateResults(for tips: [Tip]) -> [Tip: Int] {
        var dictionary = [Tip: Int]()
        for tip in tips { dictionary[tip] = 0 }     // <-- Initializes dictionary with all tips as keys.
        let copy = dictionary
        
        for entry in copy {
            for vote in allVotes {
                if let index = Int(vote.candidate.recordID.recordName), entry.key.index == index {
                    vote.isFor ?
                        (dictionary[entry.key] = entry.value + 1) : (dictionary[entry.key] = entry.value - 1)
                }
            }
        }
        
        return dictionary
    }
}

struct MockVoteCounter: VoteCounter {
    
    // MARK: - Properties: VoteCounter
    
    var allVotes = [VoteAbstraction]()

    // MARK: - Functions: Constructors
    
    init(ballots: [VoteAbstraction]) { allVotes = ballots }
}
