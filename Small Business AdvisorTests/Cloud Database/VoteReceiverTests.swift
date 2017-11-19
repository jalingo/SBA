//
//  VoteReceiverTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/16/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud

let testNotify = Notification.Name("TestNotification")

class VoteReceiverTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: MockVoteReceiver?

    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        mock = MockVoteReceiver()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions
    
    func prepareDatabase() -> Int {
        let allVotes = testVotes()
        let prepOp = Upload(allVotes, from: mock!, to: .publicDB)
        let pause = Pause(seconds: 2)
        pause.addDependency(prepOp)
        
        OperationQueue().addOperation(pause)
        OperationQueue().addOperation(prepOp)
        
        pause.waitUntilFinished()
        return 0
    }
    
    func cleanUpDatabase() -> Int {
        let allVotes = testVotes()
        let cleanUp = Delete(allVotes, of: mock!, from: .publicDB)
        let pause = Pause(seconds: 2)
        pause.addDependency(cleanUp)
        
        OperationQueue().addOperation(pause)
        OperationQueue().addOperation(cleanUp)
        
        pause.waitUntilFinished()
        return 0
    }
    
    // MARK: - Functions: Tests
    
    func testVoteReceiverReceivesRecordables() { XCTAssertNotNil(mock is ReceivesRecordable) }
    
    func testVoteReceiverCanStartListening() {
        let expect = expectation(description: "Receiver Heard Notification")
        var passed = false
        
        mock?.startListening() {
            passed = true
            expect.fulfill()
        }
        
        NotificationCenter.default.post(name: testNotify, object: nil)
        
        wait(for: [expect], timeout: 2)
        XCTAssert(passed)
    }
    
    func testVoteReceiverCanStopListening() {
        var passed = true

        mock?.startListening() { passed = false }
        mock?.stopListening()
        
        NotificationCenter.default.post(name: testNotify, object: nil)
        XCTAssert(passed)
    }
    
    func testVoteReceiverStopsListeningOnDeinit() {
        var passed = true
        
        mock?.startListening() { passed = false }
        mock = nil              // <-- This should trigger deinit and stopListening

        NotificationCenter.default.post(name: testNotify, object: nil)
        XCTAssert(passed)
    }
    
    func testVoteReceiverCanDownloadAll() {
        let _ = prepareDatabase()

        let expect = expectation(description: "All Votes Downloaded")
        mock?.download() { expect.fulfill() }
        wait(for: [expect], timeout: 3)

        let allVotes = testVotes()
        if let votes = mock?.recordables {
            XCTAssertEqual(allVotes, votes)
        } else {
            XCTFail()
        }
        
        let _ = cleanUpDatabase()
    }
    
    func testVoteReceiverDownloadsFromListening() {
        let _ = prepareDatabase()
        
        mock?.startListening()  // <-- At this point empty
        NotificationCenter.default.post(name: testNotify, object: nil)
        
        XCTAssert(mock?.recordables.count != 0)
        
        let _ = cleanUpDatabase()
    }
}

protocol VoteReceiver: ReceivesRecordable {
    
    func startListening(consequence: OptionalClosure)
    
    func stopListening(completion: OptionalClosure)
    
    func download(completion: OptionalClosure)    
}

class MockVoteReceiver: VoteReceiver {
    
    typealias type = MockVote
    
    var recordables = [MockVote]()
    
    fileprivate var observer: NSObjectProtocol?

    func startListening(consequence: OptionalClosure = nil) {
        observer = NotificationCenter.default.addObserver(forName: testNotify,
                                                          object: nil,
                                                          queue: nil) { _ in
            if let handler = consequence { handler() }
        }
    }
    
    func stopListening(completion: OptionalClosure = nil) {
        if let listener = observer {
            NotificationCenter.default.removeObserver(listener)
            if let handler = completion { handler() }
        }
    }
    
    func download(completion: OptionalClosure = nil) {
        let download = Download(type: RecordType.vote, to: self, from: .publicDB)
        download.completionBlock = completion
        OperationQueue().addOperation(download)
    }
    
    deinit { stopListening() }
}

