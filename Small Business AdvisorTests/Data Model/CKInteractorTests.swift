//
//  CKInteractorTests.swift
//  Small Biz AdvisorTests
//
//  Created by Hayley McCrory on 11/3/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import CloudKit

class CKInteractorTests: XCTestCase {
    
    // MARK: - Properties
    
    let database = CKContainer.default().publicCloudDatabase
    
    var testRecords: [CKRecord] {
        let rec0 = CKRecord(recordType: RecordType.entry)
        let rec1 = CKRecord(recordType: RecordType.entry)
        let rec2 = CKRecord(recordType: RecordType.entry)
        let rec3 = CKRecord(recordType: RecordType.vote)
        let rec4 = CKRecord(recordType: RecordType.vote)
        let rec5 = CKRecord(recordType: RecordType.vote)
        let rec6 = CKRecord(recordType: RecordType.vote)
        let rec7 = CKRecord(recordType: RecordType.vote)

        // Configure test entries
        rec0[RecordKey.rank] = NSNumber(integerLiteral: 1)
        rec1[RecordKey.rank] = NSNumber(integerLiteral: 2)
        rec2[RecordKey.rank] = NSNumber(integerLiteral: 3)
        
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
    
    var mock: CloudInteractor?
    
    // MARK: - Functions

    override func setUp() {
        super.setUp()
        mock = MockInteractor()
    }
    
    override func tearDown() {
        mock = nil
        super.tearDown()
    }
    
    /// This code assumes that records have been deleted from the database at the end of each test.
    func uploadTestRecords(completion: (()->())? = nil) {
        let op = CKModifyRecordsOperation(recordsToSave: testRecords, recordIDsToDelete: nil)
        
        op.savePolicy = .changedKeys
        op.completionBlock = completion
        op.modifyRecordsCompletionBlock = { _, _, possibleError in
            guard let error = possibleError else { return }
print("CKInteractorTests.upload: \(error.localizedDescription)")  // <-- This can be fleshed out as errors emerge.
        }
        
        database.add(op)
    }
    
    func deleteTestRecords(completion: (()->())? = nil) {
        let op = CKModifyRecordsOperation(recordsToSave: nil,
                                          recordIDsToDelete: testRecords.map({ $0.recordID }))
        op.completionBlock = completion
        op.modifyRecordsCompletionBlock = { _, _, possibleError in
            guard let error = possibleError else { return }
print("CKInteractorTests.download: \(error.localizedDescription)")  // <-- This can be fleshed out as errors emerge.
        }
        
        database.add(op)
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
            modifyOp.modifyRecordsCompletionBlock = { _, _, possibleError in
                guard let error = possibleError else { return }
print("CKInteractor.disorder: \(error)")    // <-- This can be fleshed out as errors emerge.
            }
            
            self.database.add(modifyOp)
        }
        
        database.add(fetchOp)
    }
    
    // MARK: - Functions: Tests
    
    func testCloudInteractorHasDatabase() { XCTAssertNotNil(mock?.database) }
    
    func testCloudInteractorHasAllVotes() { XCTAssertNotNil(mock?.allVotes) }
    
    func testCloudInteractorCanTabulateRanks() {

        // Test that method name is recognized.
        XCTAssertNotNil(mock?.tabulateRanks())

        // Test that tabulateResults effects allVotes
        guard let test = mock?.allVotes else { XCTFail(); return }
        mock?.tabulateRanks()
        if let current = mock?.allVotes { XCTAssertNotEqual(test, current) }
        
        // Test that allVotes is updated from the database
        
        let group = DispatchGroup()
        group.enter()
        
        uploadTestRecords() { group.leave() }
        
        group.wait()

        mock?.tabulateRanks()
        if let test = mock?.allVotes {
            XCTAssertEqual(test, testRecords)
        } else {
            XCTFail()
        }
        
        // Test that sort makes changes to database

        mixUpVoteOutcomes()
        
        mock?.tabulateRanks()
        if let test = mock?.allVotes {
            XCTAssertNotEqual(test, testRecords)
        } else {
            XCTFail()
        }
        
        let _ = cleanUpDatabase()
    }
    
    func testCloudInteractorCanQueryVotes() {

        XCTAssertNotNil(mock?.queryVotes(completion: nil))
        
        // Test that completion block is passed on
//        let testHandler: OptionalClosure = { print("") }
//        let op0 = mock?.queryVotes(completion: testHandler)
//        XCTAssert(testHandler == op0?.completionBlock as OptionalClosure)
        
        let group = DispatchGroup()
        group.enter()

        let op = mock?.queryVotes() { group.leave() }

        // Test that query is correct
        
        let predicate = NSPredicate(value: true)
        var query: CKQuery? = CKQuery(recordType: RecordType.vote,
                                      predicate: predicate)
        
        XCTAssertEqual(op?.query?.predicate, predicate)
        XCTAssertEqual(op?.query, query)
        query = nil     // <- Appeases optional query mutation warning
        
        // Test that votes get stored in all votes
       
        if let op = op {
            uploadTestRecords() { self.database.add(op) }
            group.wait()
            
            XCTAssertEqual(mock!.allVotes, testRecords)
        } else {
            XCTFail()
        }
        
        let _ = cleanUpDatabase()
    }
    
    func testCloudInteractorCanModifyRank() {
        XCTFail()
    }
}

protocol CloudInteractor {
    
    // MARK: Properties
    
    var database: CKDatabase { get }
    
    var allVotes: [CKRecord] { get set }
    
    // MARK: Functions

    mutating func tabulateRanks()
   
    func queryVotes(completion: OptionalClosure) -> CKQueryOperation
//    func modifyRank(of ref: CKReference, to rank: Int)
}

struct MockInteractor: CloudInteractor {
    
    // MARK: Properties
    
    var database: CKDatabase { return CKContainer.default().publicCloudDatabase }
    
    var allVotes = [CKRecord]()

    // MARK: Functions
    
    mutating func tabulateRanks() {
        let mockRecord = CKRecord(recordType: RecordType.mock)
        allVotes.append(mockRecord)
    }
    
    func queryVotes(completion: OptionalClosure = nil) -> CKQueryOperation {
        return CKQueryOperation()
    }

}
