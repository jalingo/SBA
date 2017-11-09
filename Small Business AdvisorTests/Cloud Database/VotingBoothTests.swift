//
//  VotingBoothTests.swift
//  Small Biz AdvisorTests
//
//  Created by Hayley McCrory on 11/8/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class VotingBoothTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: VotingBooth?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = MockVotingBooth()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testVotingBoothCanModifyVote() {
        
    }
    
    func testVotingBoothCanCheckVote() {
        
    }
}

protocol VotingBooth: AnyObject {
    
    func modifyVote(up increase: Bool, rank: Int)
}

class MockVotingBooth: UIViewController, VotingBooth {

    
    func modifyVote(up increase: Bool, rank: Int) {
        
    }
}
