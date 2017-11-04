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
    
    let testRecord = CKRecord(recordType: "Test_Record")
    
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
    
    func uploadTestRecord(completion: (()->())? = nil) {
        
    }
    
    func deleteTestRecor(completion: (()->())? = nil) {
        
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
        
        uploadTestRecord() { group0.leave() }
        group0.wait()

        mock?.tabulateRanks()
        if let test = mock?.allVotes {
            XCTAssertEqual(test, [testRecord])
        } else {
            XCTFail()
        }
        
        let group1 = DispatchGroup()
        group1.enter()
        
        uploadTestRecord() { group1.leave() }
        group1.wait()
        
        // Test that sort makes changes
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
