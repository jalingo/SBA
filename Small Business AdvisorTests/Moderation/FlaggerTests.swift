//
//  FlaggerTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import CloudKit
import MagicCloud

class FlaggerTests: XCTestCase {
    
    // MARK: - Properties
    
    var mock: Flagger?
    
    // MARK: - Functions

    func attachThreeFlags(to tip: MockTip) {
        for index in 1...3 { attachFlag(to: tip, index: index) }
    }
    
    func attachFlag(to tip: MockTip, index: Int) {
        guard let creator = MCUserRecord().singleton else { return }

        var flag = Flag()
        flag.creator = creator
        flag.tip = CKReference(recordID: tip.recordID, action: .deleteSelf)
        flag.recordID = CKRecordID(recordName: "TEST_#\(index)")
        
        let op = MCUpload([flag], from: mock!, to: .publicDB)
        OperationQueue().addOperation(op)
        
        op.waitUntilFinished()
    }
    
    func cleanUpFlags() {
        var ids = [CKRecordID]()
        for index in 1...3 { ids.append(CKRecordID(recordName: "TEST_#\(index)")) }
        
        let op = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: ids)
        op.modifyRecordsCompletionBlock = { possibleSaves, possibleDels, possibleError in
            print("** cleanUpFlags errors\(String(describing: possibleError))")
        }
        
        OperationQueue().addOperation(op)
        op.waitUntilFinished()
    }
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = Flagger(db: .publicDB)
    }
    
    override func tearDown() {
        cleanUpFlags()
        
        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Unit Tests
    
    func testFlaggerCanReturnFlagsByTip() {
        let tip = MockTip(index: -1,
                          category: .outOfRange,
                          text: NSAttributedString(string: "Mock Tip Text",
                                                   attributes: Format.bodyText))
        
        attachThreeFlags(to: tip)
        mock?.downloadAll(from: .publicDB)
        
        let pause = Pause(seconds: 2)
        OperationQueue().addOperation(pause)

        pause.waitUntilFinished()
        if let flags = mock?.flags(for: tip.recordID) {
            XCTAssert(flags.count == 3)
        } else {
            XCTFail()
        }
    }
    
    func testFlaggerCanPostNewFlag() {
        var testFlag = Flag()
        testFlag.recordID = CKRecordID(recordName: "TEST_#1")
        mock?.post(testFlag)
        
        let pause = Pause(seconds: 2)
        OperationQueue().addOperation(pause)
        
        pause.waitUntilFinished()
        if let result = mock?.recordables.contains(where: { $0.recordID.recordName == testFlag.recordID.recordName }) {
            XCTAssert(result)
        } else {
            XCTFail()
        }
    }
}

extension MockTip {
    var recordID: CKRecordID { return CKRecordID(recordName: "MockTip") }
}



