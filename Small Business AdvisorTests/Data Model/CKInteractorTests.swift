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
    
    var testRecords: [CKRecord] {
        let rec0 = CKRecord(recordType: "Test_Record")
        let rec1 = CKRecord(recordType: "Test_Record")
        let rec2 = CKRecord(recordType: "Test_Record")

        rec0["Rank"] = NSNumber(integerLiteral: 1)
        rec1["Rank"] = NSNumber(integerLiteral: 2)
        rec2["Rank"] = NSNumber(integerLiteral: 3)

        return [rec0, rec1, rec2]
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
    
    func uploadTestRecords(completion: (()->())? = nil) {
        
        // This code assumes that records have been deleted from the database at the end of each test.
        let op = CKModifyRecordsOperation(recordsToSave: testRecords, recordIDsToDelete: nil)
        
        
    }
    
    func deleteTestRecords(completion: (()->())? = nil) {
        
    }
    
    func disorderDatabaseRecords(completion: (()->())? = nil) {
        
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
        
        let group0 = DispatchGroup()
        group0.enter()
        
        uploadTestRecords() { group0.leave() }
        group0.wait()

        mock?.tabulateRanks()
        if let test = mock?.allVotes {
            XCTAssertEqual(test, testRecords)
        } else {
            XCTFail()
        }
        
        // Test that sort makes changes to database

        disorderDatabaseRecords()
        
        mock?.tabulateRanks()
        if let test = mock?.allVotes {
            XCTAssertEqual(test, testRecords)
        } else {
            XCTFail()
        }
        
        // Clean up database
        
        let group1 = DispatchGroup()
        group1.enter()
        
        deleteTestRecords() { group1.leave() }
        group1.wait()
    }
}

protocol CloudInteractor {
    
    // MARK: Properties
    
    var database: CKDatabase { get }
    
    var allVotes: [CKRecord] { get set }
    
    // MARK: Functions

    mutating func tabulateRanks()
   
//    func queryVotes()
//    func modifyRank(of ref: CKReference, to rank: Int)
}

struct MockInteractor: CloudInteractor {
    
    // MARK: Properties
    
    var database: CKDatabase { return CKContainer.default().publicCloudDatabase }
    
    var allVotes = [CKRecord]()

    // MARK: Functions
    
    mutating func tabulateRanks() {
        let mockRecord = CKRecord(recordType: "MockType")
        allVotes.append(mockRecord)
    }
}
