//
//  VoteReceiverTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/16/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud

//extension ReceivesRecordable {
//    /**
//        This protected property is an array of Tips used by reciever.
//     */
//    var recordables = [type]() {
//        didSet {
//            print("** TipReceiver didSet: \(recordables.count)")
//            
//            guard allowRecordablesDidSetToUploadDataModel else { return }
//            
//            let op = Upload(from: self, to: .publicDB)
//            OperationQueue().addOperation(op)
//            
//            // This resets trigger safety
//            allowRecordablesDidSetToUploadDataModel = false
//        }
//    }
//    
//    /**
//        This boolean property allows / prevents changes to `recordables` being stored in
//        the cloud.
//     */
////    var allowRecordablesDidSetToUploadDataModel: Bool = false
//    
//    // !!
//    func refresh(completion: OptionalClosure = nil) {
//        recordables = []    // <- Clears out current recordables for batch download.
//        
//        let op = Download(to: self, from: .privateDB)
//        op.completionBlock = completion
//        OperationQueue().addOperation(op)
//    }
//}

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
    
    // MARK: - Functions: Tests
    
    func testVoteReceiverReceivesRecordables() { XCTAssertNotNil(mock is ReceivesRecordable) }
    
    func testVoteReceiverCanStartListening() {
        
    }
    
    func testVoteReceiverCanStopListening() {
        
    }
    
    func testVoteReceiverCanDownloadAll() {
        
    }
    
    func testVoteReceiverCanUploadSpecificNew() {
        
    }
    
    func testVoteReceiverCanUploadChanges() {
        
    }
    
    func testVoteReceiverCanRemoveVote() {
        
    }
}

protocol VoteReceiver: ReceivesRecordable {
    
}

class MockVoteReceiver: VoteReceiver {
    
    typealias type = Tip    // <- Switch to vote
    
    var recordables = [Tip]()

}

