//
//  TestTools.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/8/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import CloudKit
@testable import MagicCloud

// MARK: - Properties: Global

let testDatabase = CKContainer.default().publicCloudDatabase

var mixedUpVotes: [CKRecordID]?

var testRecords: [CKRecord] {
    let rec0 = CKRecord(recordType: RecordType.entry, recordID: CKRecordID(recordName: "entry0"))
    let rec1 = CKRecord(recordType: RecordType.entry, recordID: CKRecordID(recordName: "entry1"))
    let rec2 = CKRecord(recordType: RecordType.entry, recordID: CKRecordID(recordName: "entry2"))
    let rec3 = CKRecord(recordType: RecordType.vote, recordID: CKRecordID(recordName: "vote0"))
    let rec4 = CKRecord(recordType: RecordType.vote, recordID: CKRecordID(recordName: "vote1"))
    let rec5 = CKRecord(recordType: RecordType.vote, recordID: CKRecordID(recordName: "vote2"))
    let rec6 = CKRecord(recordType: RecordType.vote, recordID: CKRecordID(recordName: "vote3"))
    let rec7 = CKRecord(recordType: RecordType.vote, recordID: CKRecordID(recordName: "vote4"))
    
    // Configure test entries
    rec0[RecordKey.rank] = NSNumber(integerLiteral: 1)
    rec0[RecordKey.indx] = NSNumber(integerLiteral: 1)
    rec1[RecordKey.rank] = NSNumber(integerLiteral: 2)
    rec1[RecordKey.indx] = NSNumber(integerLiteral: 2)
    rec2[RecordKey.rank] = NSNumber(integerLiteral: 3)
    rec2[RecordKey.indx] = NSNumber(integerLiteral: 3)

    // Configure test votes
    rec3[RecordKey.refs] = CKReference(record: rec0, action: .deleteSelf)
    rec3[RecordKey.appr] = true as CKRecordValue
    rec4[RecordKey.refs] = CKReference(record: rec0, action: .deleteSelf)
    rec4[RecordKey.appr] = true as CKRecordValue
    rec5[RecordKey.refs] = CKReference(record: rec1, action: .deleteSelf)
    rec5[RecordKey.appr] = true as CKRecordValue
    rec6[RecordKey.refs] = CKReference(record: rec1, action: .deleteSelf)
    rec6[RecordKey.appr] = false as CKRecordValue
    rec7[RecordKey.refs] = CKReference(record: rec2, action: .deleteSelf)
    rec7[RecordKey.appr] = false as CKRecordValue
    
    return [rec0, rec1, rec2, rec3, rec4, rec5, rec6, rec7]
}

// MARK: - Functions: Global

func testTips() -> [Tip] {
    var tips = [Tip]()
    for index in 1...TipFactory.max {
        let tip = Tip(index: index,
                      category: TipCategoryFactory.produceByIndex(index: index),
                      text: TextFactory.produce(for: index))
        tips.append(tip)
    }
    
    return tips
}

func testVotes() -> [MockVote] {
    var votes = [MockVote]()
    
    // This test will have to be changed when entries move to the database
    for index in 1...TipFactory.max {
        let tip = CKRecordID(recordName: "\(index)")
        let candidate = CKReference(recordID: tip, action: .deleteSelf)
        
        let ref: CKReference
        if let user = getCurrentUserRecord() {
            ref = CKReference(recordID: user, action: .deleteSelf)
        } else {
            let id = CKRecordID(recordName: "MockUser")
            ref = CKReference(recordID: id, action: .deleteSelf)
        }
        
        // Stack votes based on index order
        for _ in 1...(TipFactory.max - index) {
            let vote = MockVote(up: true, candidate: candidate, constituent: ref)
            votes.append(vote)
        }
    }
    
    return votes
}

/// This code assumes that records have been deleted from the database at the end of each test.
func uploadTestRecords(completion: (()->())? = nil) {
    let op = CKModifyRecordsOperation(recordsToSave: testRecords, recordIDsToDelete: nil)
    
    let pause = Pause(seconds: 3)
    pause.addDependency(op)
    pause.completionBlock = completion
    OperationQueue().addOperation(pause)
    
    op.savePolicy = .changedKeys
    op.modifyRecordsCompletionBlock = { _, _, possibleError in
        guard let error = possibleError else { return }
        print("** CKInteractorTests.upload: \(error.localizedDescription)")  // <-- !! This can be fleshed out as errors emerge.
    }
    
    testDatabase.add(op)
}

func prepareDatabase() -> Int {
    let group = DispatchGroup()
    group.enter()
    
    uploadTestRecords() { group.leave() }
    group.wait()
    
    return -1
}

func deleteTestRecords(completion: (()->())? = nil) {
    var recordsToDelete = testRecords.map() { $0.recordID }
    if let mixed = mixedUpVotes { recordsToDelete += mixed }
    
    let op = CKModifyRecordsOperation(recordsToSave: nil,
                                      recordIDsToDelete: recordsToDelete)
    op.completionBlock = completion
    op.isLongLived = true
    op.modifyRecordsCompletionBlock = { _, _, possibleError in
        guard let error = possibleError else { return }
        print("** CKInteractorTests.delete: \(error)")  // <-- This can be fleshed out as errors emerge.
    }
    
    testDatabase.add(op)
}

func cleanUpDatabase() -> Int {
    let group = DispatchGroup()
    group.enter()
    
    deleteTestRecords() { group.leave() }
    group.wait()
    
    return -1
}

func mixUpVoteOutcomes(completion: (()->())? = nil) {
    var votesToModify = [CKRecordID]()
    
    var index = 0
    for record in testRecords {
        if index > 2 { votesToModify.append(record.recordID) }
        index += 1
    }
    
    let fetchOp = CKFetchRecordsOperation(recordIDs: votesToModify)
    fetchOp.fetchRecordsCompletionBlock = { possibleRecords, possibleError in
        if let error = possibleError { print(error) }
        
        var modifiedRecords = [CKRecord]()
        var absenteeVotes = [CKRecordID]()
        
        if let records = possibleRecords {
            for vote in votesToModify {
                if records.keys.contains(vote),
                    let record = records[vote],
                    let approval = record[RecordKey.appr] as? Bool {
                    record[RecordKey.appr] = approval as CKRecordValue
                    modifiedRecords.append(record)
                } else {
                    absenteeVotes.append(vote)
                }
            }
        } else {
            absenteeVotes = votesToModify
        }
        
        for vote in absenteeVotes {
            let record = CKRecord(recordType: RecordType.vote, recordID: vote)
            modifiedRecords.append(record)
        }
        
        let modifyOp = CKModifyRecordsOperation(recordsToSave: modifiedRecords, recordIDsToDelete: nil)
        modifyOp.completionBlock = completion
        modifyOp.savePolicy = .changedKeys
        modifyOp.modifyRecordsCompletionBlock = { _, possibleIDs, possibleError in
            mixedUpVotes = possibleIDs                 // <-- This line is required for cleanUp to be effective later.
            guard let error = possibleError else { return }
            print("** CKInteractor.disorder: \(error)")                     // <-- This can be fleshed out as errors emerge.
        }
        
        testDatabase.add(modifyOp)
    }
    
    testDatabase.add(fetchOp)
}
