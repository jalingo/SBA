//
//  VoteTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/17/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
@testable import MagicCloud
import CloudKit

class VoteTests: XCTestCase {
    
    // MARK: - Properties

    let testVoter = CKRecordID(recordName: "TestVoter")
    
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
    
    func testVoteAbstractionIsReceivesRecordable() {
        XCTAssert(mock is MCRecordable)
        
        let altID = CKRecordID(recordName: "AltRecord")
        let altMock = MockVote(up: !mock!.isFor,
                               candidate: CKReference(recordID: altID, action: .deleteSelf),
                               constituent: CKReference(recordID: testVoter, action: .deleteSelf))
        mock?.recordFields = altMock.recordFields
        
        if let vote = mock as? MockVote { XCTAssertEqual(altMock, vote) }
    }

    func testVoteHasDirection() { XCTAssertNotNil(mock?.isFor) }
    
    func testVoteCanWriteDirection() {
        let vote = false
        mock?.isFor = vote
        
        XCTAssertEqual(vote, mock?.isFor)
    }
    
    func testVoteHasCandidate() { XCTAssertNotNil(mock?.candidate) }
    
    func testVoteCanWriteCandidate() {
        let testTip = CKRecordID(recordName: "\(Tip().index)")
        mock?.candidate = CKReference(recordID: testTip, action: .deleteSelf)

        XCTAssertEqual(testTip, mock?.candidate.recordID)
    }
    
    func testVoteHasConstituent() { XCTAssertNotNil(mock?.constituent) }
    
    func testVoteCanWriteConstituent() {
        mock?.constituent = CKReference(recordID: testVoter, action: .deleteSelf)
        XCTAssertEqual(testVoter, mock?.constituent.recordID)
    }
}

struct MockVote: VoteAbstraction {

    // MARK: - Properties
    
    // MARK: - Properties: VoteAbstraction
    
    var isFor = true
    
    fileprivate var ballotMeasure = CKRecordID(recordName: "MockTip")
    var candidate: CKReference {
        get { return CKReference(recordID: ballotMeasure, action: .deleteSelf) }
        set { ballotMeasure = newValue.recordID }
    }

    fileprivate var voterID = CKRecordID(recordName: "MockVoter")
    var constituent: CKReference {
        get { return CKReference(recordID: voterID, action: .deleteSelf) }
        set { voterID = newValue.recordID }
    }
    
    // MARK: - Properties: Recordable
    
    var recordType: String = RecordType.vote
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dictionary = Dictionary<String, CKRecordValue>()
            
            dictionary[RecordKey.Vote.appr] = isFor as CKRecordValue
            dictionary[RecordKey.Vote.subj] = candidate as CKRecordValue
            dictionary[RecordKey.Vote.votr] = constituent as CKRecordValue
            
            return dictionary
        }
        
        set {
            if let bool = newValue[RecordKey.Vote.appr] as? Bool { isFor = bool }
            if let ref  = newValue[RecordKey.Vote.subj] as? CKReference { candidate = ref }
            if let ref  = newValue[RecordKey.Vote.votr] as? CKReference { constituent = ref }
        }
    }
    
    var recordID = CKRecordID(recordName: "MockVote")
    
    // MARK: - Functions
    
    init() {
        self.isFor = true
        
        let defaultCandidate = CKRecordID(recordName: "DefaultCandidate")
        self.candidate = CKReference(recordID: defaultCandidate, action: .deleteSelf)
        
        let defaultConstituent = CKRecordID(recordName: "DefaultConstituent")
        self.constituent = CKReference(recordID: defaultConstituent, action: .deleteSelf)
    }
    
    init(up direction: Bool, candidate subject: CKReference, constituent voter: CKReference) {
        self.isFor = direction
        self.candidate = subject
        self.constituent = voter
    }
}

extension MockVote: Equatable {
    static func ==(lhs: MockVote, rhs: MockVote) -> Bool {
        return lhs.candidate.isEqual(rhs.candidate) && lhs.constituent.isEqual(rhs.constituent)
    }
}

