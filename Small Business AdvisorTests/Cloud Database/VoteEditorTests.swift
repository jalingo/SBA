//
//  VoteEditorTests.swift
//  Small Biz AdvisorTests
//
//  Created by Hayley McCrory on 11/18/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
@testable import MagicCloud

class VoteEditorTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: VoteEditor?
    
    var mockRec = MockVoteReceiver()
    
    // MARK: - Functions
    
    func prepareDatabase() -> Int {
        let allVotes = testVotes()
        let prepOp = MCUpload(allVotes, from: mockRec, to: .publicDB)
        let pause = Pause(seconds: 2)
        pause.addDependency(prepOp)
        
        OperationQueue().addOperation(pause)
        OperationQueue().addOperation(prepOp)
        
        pause.waitUntilFinished()
        return 0
    }
    
    func cleanUpDatabase() -> Int {
        let allVotes = testVotes()
        let cleanUp = MCDelete(allVotes, of: mockRec, from: .publicDB)
        let pause = Pause(seconds: 2)
        pause.addDependency(cleanUp)
        
        OperationQueue().addOperation(pause)
        OperationQueue().addOperation(cleanUp)
        
        pause.waitUntilFinished()
        return 0
    }
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        
        mockRec = MockVoteReceiver()
        mock = MockVoteEditor(for: mockRec)
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }

    // MARK: - Functions: Tests
    
    func testVoteEditorCanUploadNew() {
        let vote = MockVote()
        mock?.add(vote)

        mockRec.download()
        let pause = Pause(seconds: 2)
        pause.start()
        
        pause.waitUntilFinished()
        XCTAssertEqual(vote, mockRec.recordables.first)
        
        let _ = cleanUpDatabase()
    }
        
    func testVoteEditorCanRemoveVote() {
        let _ = prepareDatabase()
        
        mockRec.download()
        let pause0 = Pause(seconds: 2)
        pause0.start()
        
        pause0.waitUntilFinished()
        if let vote = mockRec.recordables.first {
            mockRec.startListening()        // <-- Should stop listening on deinit (see unit tests).
            mock?.remove(vote)
            
            let pause1 = Pause(seconds: 5)  // <-- During this vote should be removed from the database,
            pause1.start()                  //     which should trigger a notification, then download and
                                            //     finally recordables should not have vote.
            pause1.waitUntilFinished()
            XCTAssertNotEqual(mockRec.recordables.first, vote)
            XCTAssertFalse(mockRec.recordables.contains(vote))
        } else {
            XCTFail()
        }
        
        let _ = cleanUpDatabase()
    }
}

protocol VoteEditor {
    
    typealias type = MockVote
    
    func add(_ vote: type)
    
    func remove(_ vote: type)
}

struct MockVoteEditor: VoteEditor {

    typealias type = MockVote
    
    let rec: MockVoteReceiver
    
    func add(_ vote: type) {
        let op = MCUpload([vote], from: rec, to: .publicDB)
        OperationQueue().addOperation(op)
    }
    
    func remove(_ vote: type) {
        let op = MCDelete([vote], of: rec, from: .publicDB)
        OperationQueue().addOperation(op)
    }
    
    init(for receiver: MockVoteReceiver) { rec = receiver }
}
