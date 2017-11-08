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
    
    // MARK: - Functions: Test
    
    /// This code assumes that records have been deleted from the database at the end of each test.
    func uploadTestRecords(completion: (()->())? = nil) {
        let op = CKModifyRecordsOperation(recordsToSave: testRecords, recordIDsToDelete: nil)
print("** uploading...")
        let pause = Pause(seconds: 3)
        pause.addDependency(op)
        pause.completionBlock = completion
        OperationQueue().addOperation(pause)

        op.savePolicy = .changedKeys
        op.modifyRecordsCompletionBlock = { _, _, possibleError in
            guard let error = possibleError else { print("** finished upload, no error"); return }
print("** CKInteractorTests.upload: \(error.localizedDescription)")  // <-- This can be fleshed out as errors emerge.
        }
        
        database.add(op)
    }
    
    func prepareDatabase() -> Int {
        let group = DispatchGroup()
        group.enter()
print("** prepping...")
        uploadTestRecords() { group.leave() }
        group.wait()
print("** finished prepping.")
        return -1
    }
    
    func deleteTestRecords(completion: (()->())? = nil) {
        let op = CKModifyRecordsOperation(recordsToSave: nil,
                                          recordIDsToDelete: testRecords.map({ $0.recordID }))
print("** deleting...\(op.recordIDsToDelete!.count)")
        op.completionBlock = completion
        op.isLongLived = true
op.longLivedOperationWasPersistedBlock = { print("** deletion persisted") }
        op.modifyRecordsCompletionBlock = { _, _, possibleError in
            guard let error = possibleError else { print("** finished delete, no error"); return }
print("** CKInteractorTests.delete: \(error)")  // <-- This can be fleshed out as errors emerge.
        }
        
        database.add(op)
    }
    
    func cleanUpDatabase() -> Int {
        let group = DispatchGroup()
        group.enter()
print("** cleaning...")
        deleteTestRecords() { group.leave() }
        group.wait()
print("** finished cleaning.")
        return -1
    }
    
    func mixUpVoteOutcomes(completion: (()->())? = nil) {
        var votesToModify = [CKRecordID]()
print("** mixing...")
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
print("** CKInteractor.disorder: \(error)")    // <-- This can be fleshed out as errors emerge.
            }
            
            self.database.add(modifyOp)
        }
        
        database.add(fetchOp)
    }
    
    // MARK: - Functions: Tests
    
    func testCloudInteractorHasDatabase() { XCTAssertNotNil(mock?.database) }
    
    func testCloudInteractorHasAllVotes() { XCTAssertNotNil(mock?.allVotes) }
    
    func testCloudInteractorCanTabulateRanks() {
        let _ = prepareDatabase()
        
        // Test that method name is recognized.
        XCTAssertNotNil(mock?.tabulateRanks())

        // Test that tabulateResults effects allVotes
        
        guard let test = mock?.allVotes else { XCTFail(); return }
        mock?.tabulateRanks()
        if let current = mock?.allVotes { XCTAssertNotEqual(test, current) }
        
        // Test that allVotes is updated from the database

        mock?.tabulateRanks()
        if let test = mock?.allVotes {
            XCTAssertEqual(test, testRecords)
        } else {
            XCTFail()
        }
        
        // Test that sort makes changes to database

        mixUpVoteOutcomes()             // <-- Requires additional database clean up !!
        
        mock?.tabulateRanks()
        if let test = mock?.allVotes {
            XCTAssertNotEqual(test, testRecords)
        } else {
            XCTFail()
        }
        
        let _ = cleanUpDatabase()
    }
    
    func testCloudInteractorCanQueryVotes() {
        let _ = prepareDatabase()

        XCTAssertNotNil(mock?.queryVotes(completion: nil))
        
        let group = DispatchGroup()
        group.enter()

        let op = mock?.queryVotes() { group.leave() }

        // Test that query is correct

        let predicate = NSPredicate(value: true)
        var query: CKQuery? = CKQuery(recordType: RecordType.vote,
                                      predicate: predicate)
        
        XCTAssertEqual(op?.query?.predicate, predicate)
        XCTAssertEqual(op?.query?.recordType, query?.recordType)
        query = nil     // <- Appeases optional query mutation warning
        
        // Test that votes get stored in all votes

        if let op = op {
            self.database.add(op)
            group.wait()
            
            let testVotes = testRecords.filter({ $0.recordType == RecordType.vote })
            XCTAssertEqual(mock!.allVotes.count, testVotes.count)
        } else {
            XCTFail()
        }

        let _ = cleanUpDatabase()
    }
    
    func testCloudInteractorCanSortDictionary() {
        let ref0 = CKReference(recordID: CKRecordID(recordName: "firstRef"), action: .deleteSelf)
        let ref1 = CKReference(recordID: CKRecordID(recordName: "secondRef"), action: .deleteSelf)
        let ref2 = CKReference(recordID: CKRecordID(recordName: "thirdRef"), action: .deleteSelf)

        let orderedSample = [ref0: NSNumber(value: 1), ref1: NSNumber(value: 2), ref2: NSNumber(value: 3)]
        let disorderedSample = [ref0: NSNumber(value: 1), ref2: NSNumber(value: 3), ref1: NSNumber(value: 2)]

        if let sample = mock?.sorted(disorderedSample) {
            XCTAssertEqual(Array(orderedSample.keys), sample)
        } else {
            XCTFail()
        }
    }
    
    func testCloudInteractorCanModifyRank() {
        let _ = prepareDatabase()

        let original = testRecords[0]                                                    // rank = 1
        mock?.modifyRank(of: CKReference(record: original, action: .deleteSelf), to: 9)  // rank = 9
        
        let group = DispatchGroup()
        group.enter()
        
        // Give time for database to be modified.
        let pause = Pause(seconds: 3)
        pause.completionBlock = { group.leave() }
        OperationQueue().addOperation(pause)
        group.wait()

        if let modified = mock?.getEntry(for: 9) {
            XCTAssertEqual(original.recordID, modified.recordID)
        } else {
            XCTFail()
        }

        let _ = cleanUpDatabase()
    }
    
    func testCloudInteractorCanGetRecordByRank() {
        let _ = prepareDatabase()

        XCTAssertNotNil(mock?.getEntry(for: 1))

        let firstPlace = testRecords[0]
        XCTAssertEqual(firstPlace.recordID, mock?.getEntry(for: 1)?.recordID)

        let _ = cleanUpDatabase()
    }
}

protocol CloudInteractor: AnyObject {   // <- Object required (class, not structs)
    
    // MARK: Properties
    
    var database: CKDatabase { get }
    
    var allVotes: [CKRecord] { get set }
    
    // MARK: Functions

    func tabulateRanks()
   
    func queryVotes(completion: OptionalClosure) -> CKQueryOperation
    
    func modifyRank(of ref: CKReference, to rank: Int)
    
    func getEntry(for rank: Int) -> CKRecord?
    
    func sorted(_ :[CKReference: NSNumber]) -> [CKReference]
}

class MockInteractor: CloudInteractor {
    
    // MARK: - Enums
    
    enum QueryOptions {
        case allVotes, getEntry
    }
    
    // MARK: - Properties
    
    fileprivate var recoveredRecord: CKRecord?

    // MARK: - Properties: CloudInteractor
    
    var database: CKDatabase { return CKContainer.default().publicCloudDatabase }
    
    var allVotes = [CKRecord]()
    
    // MARK: Functions
    
    fileprivate func decorate(queryOp op: CKQueryOperation, option: QueryOptions, completion: OptionalClosure) -> CKQueryOperation {
        op.completionBlock = completion
        op.queryCompletionBlock = queryBlock(for: op, option: option)

        let allVotesBlock = { record in
            self.allVotes.append(record)
        }
        
        let getEntryBlock = { record in
            self.recoveredRecord = record
        }
        
        option == .allVotes ? (op.recordFetchedBlock = allVotesBlock) : (op.recordFetchedBlock = getEntryBlock)
print("** decorated")
        return op
    }
    
    fileprivate func queryBlock(for op: CKQueryOperation, option: QueryOptions) -> QueryBlock {
        return { possibleCursor, possibleError in
            if let error = possibleError {
                option == .allVotes ?
                    (print("** mockInteractor.queryVotes: \(error)")) : (print("** mockInteractor.getEntry: \(error)"))
            }
            if let cursor = possibleCursor {
                let nextOp = CKQueryOperation(cursor: cursor)
                self.database.add(self.decorate(queryOp: nextOp, option: option, completion: op.completionBlock))
                op.completionBlock = nil
            }
        }
    }
    
    // MARK: - Functions: CloudInteractor
    
    func tabulateRanks() {
        allVotes = []
        
        let group = DispatchGroup()
        group.enter()

        let votes = queryVotes() { group.leave() }
        database.add(votes)
        group.wait()
        
        var results = [CKReference: NSNumber]()
        for vote in allVotes {
            guard let isIncrease = (vote[RecordKey.appr] as? NSNumber)?.boolValue else { return }
            guard let entries = (vote[RecordKey.refs] as? [CKReference]) else { return }
            let entry = entries[0]  // <-- As a vote, the only reference should be the entry to which the vote was applied (creator in metadata).

            // This tallies all votes
            if let tally = results[entry]?.intValue {
                isIncrease ?
                    (results[entry] = NSNumber(value: tally + 1)) : (results[entry] = NSNumber(value: tally - 1))
            } else {
                isIncrease ?
                    (results[entry] = NSNumber(value: 1)) : (results[entry] = NSNumber(value: -1))
            }
            
            var count = 1
            // TODO: finish this section after sorted tests and ensure checks for rank replacement
//            !!
        }
    }
    
    func queryVotes(completion: OptionalClosure = nil) -> CKQueryOperation {
        let query: CKQuery = CKQuery(recordType: RecordType.vote,
                                      predicate: NSPredicate(value: true))
        let op = CKQueryOperation(query: query)

        return decorate(queryOp: op, option: .allVotes, completion: completion)
    }
    
    func sorted(_ results: [CKReference: NSNumber]) -> [CKReference] {
        return results.keys.sorted(by: { results[$0]!.intValue > results[$1]!.intValue })   // <- ! v ?
    }
    
    func modifyRank(of ref: CKReference, to rank: Int) {
        let fetchOp = CKFetchRecordsOperation(recordIDs: [ref.recordID])
        fetchOp.perRecordCompletionBlock = { possibleRecord, possibleID, possibleError in
            if let record = possibleRecord {
                record[RecordKey.rank] = rank as CKRecordValue
                
                let modifyOp = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
                modifyOp.modifyRecordsCompletionBlock = { possibleRecords, possibleIDs, possibleError in
                    if let error = possibleError { print("** MockInteractor.modifyRank.modify error: \(error)") }
                }
                
                self.database.add(modifyOp)
            }
            
            if let error = possibleError { print("** MockInteractor.modifyRank.fetch error: \(error)") }
        }
        
        database.add(fetchOp)
    }

    func getEntry(for rank: Int) -> CKRecord? {
        let group = DispatchGroup()
        group.enter()

        let predicate = NSPredicate(format: "\(RecordKey.rank) = \(rank)")
        let query = CKQuery(recordType: RecordType.entry, predicate: predicate)
        let op = CKQueryOperation(query: query)
        let block: OptionalClosure = { group.leave() }

        database.add(decorate(queryOp: op, option: .getEntry, completion: block))
        group.wait()

        return recoveredRecord
    }
}

