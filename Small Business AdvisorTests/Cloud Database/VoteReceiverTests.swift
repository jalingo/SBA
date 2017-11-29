//
//  VoteReceiverTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/16/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

//import XCTest
//import CloudKit
//@testable import MagicCloud
//
//class VoteReceiverTests: XCTestCase {
//    
//    // MARK: - Properties
//    
//    var mock: MockVoteReceiver?
//
//    // MARK: - Functions
//    
//    override func setUp() {
//        super.setUp()
//        mock = MockVoteReceiver()
//    }
//    
//    override func tearDown() {
//        mock = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Functions
//    
//    func prepareDatabase() -> Int {
//        let allVotes = testVotes()
//        let prepOp = Upload(allVotes, from: mock!, to: .publicDB)
//        let pause = Pause(seconds: 2)
//        pause.addDependency(prepOp)
//        
//        OperationQueue().addOperation(pause)
//        OperationQueue().addOperation(prepOp)
//        
//        pause.waitUntilFinished()
//        return 0
//    }
//    
//    func cleanUpDatabase() -> Int {
//        let allVotes = testVotes()
//        let cleanUp = Delete(allVotes, of: mock!, from: .publicDB)
//        let pause = Pause(seconds: 2)
//        pause.addDependency(cleanUp)
//        
//        OperationQueue().addOperation(pause)
//        OperationQueue().addOperation(cleanUp)
//        
//        pause.waitUntilFinished()
//        return 0
//    }
//    
//    // MARK: - Functions: Tests
//    
//    func testVoteReceiverReceivesRecordables() { XCTAssertNotNil(mock is ReceivesRecordable) }
//    
//    func testVoteReceiverCanStartListening() {
//        let expect = expectation(description: "Receiver Heard Notification")
//        var passed = false
//        
//        mock?.startListening() {
//            passed = true
//            expect.fulfill()
//        }
//        
//        NotificationCenter.default.post(name: Notification.Name(mock!.notifyCreated), object: nil)
//        
//        wait(for: [expect], timeout: 2)
//        XCTAssert(passed)
//    }
//    
//    func testVoteReceiverCanStopListening() {
//        var passed = true
//
//        mock?.startListening() { passed = false }
//        mock?.stopListening()
//        
//        NotificationCenter.default.post(name: Notification.Name(mock!.notifyUpdated), object: nil)
//        XCTAssert(passed)
//    }
//    
//    func testVoteReceiverStopsListeningOnDeinit() {
//        var passed = true
//        
//        mock?.startListening() { passed = false }
//        mock = nil              // <-- This should trigger deinit and stopListening
//
//        NotificationCenter.default.post(name: Notification.Name(mock!.notifyDeleted), object: nil)
//        XCTAssert(passed)
//    }
//    
//    func testVoteReceiverCanDownloadAll() {
//        let _ = prepareDatabase()
//
//        let expect = expectation(description: "All Votes Downloaded")
//        mock?.download() { expect.fulfill() }
//        wait(for: [expect], timeout: 3)
//
//        let allVotes = testVotes()
//        if let votes = mock?.recordables {
//            XCTAssertEqual(allVotes, votes)
//        } else {
//            XCTFail()
//        }
//        
//        let _ = cleanUpDatabase()
//    }
//    
//    func testVoteReceiverDownloadsFromListening() {
//        let _ = prepareDatabase()
//        
//        mock?.startListening()  // <-- At this point empty
//        NotificationCenter.default.post(name: Notification.Name(mock!.notifyUpdated), object: nil)
//        
//        XCTAssert(mock?.recordables.count != 0)
//        
//        let _ = cleanUpDatabase()
//    }
//}
//
//protocol VoteReceiver: ReceivesRecordable {     // <-- Refactor out to ReceivesRecordable, implement as extension
//    
//    var notifyCreated: String { get }
//    
//    var notifyUpdated: String { get }
//    
//    var notifyDeleted: String { get }
//    
//    func startListening(consequence: OptionalClosure)
//    
//    func stopListening(completion: OptionalClosure)
//    
//    func download(completion: OptionalClosure)    
//}
//
//// !!
//extension VoteReceiver {
//    
//    // TODO: These need to be pulled from extension when switched to receiver.
//    var notifyCreated: String { return RecordType.vote + " created" }
//    var notifyDeleted: String { return RecordType.vote + " deleted" }
//    var notifyUpdated: String { return RecordType.vote + " updated" }
//    
//    // !! Automatically triggers download when heard
//    func startListening(consequence: OptionalClosure = nil) {
//
//    }
//    
//    // !!
//    func stopListening(completion: OptionalClosure = nil) {
//    }
//}
//
//class MockVoteReceiver: VoteReceiver {
//    
//    typealias type = MockVote
//    
//    var subscription = Subscriber()
//    
//    var recordables = [type]()
//    
//    var voteObserver: NSObjectProtocol?
//    
//    func download(completion: OptionalClosure = nil) {
//        let download = Download(type: RecordType.vote, to: self, from: .publicDB)
//        download.completionBlock = completion
//        OperationQueue().addOperation(download)
//    }
//    
//    deinit { stopListening() }
//}

