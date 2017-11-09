//
//  TestTools.swift
//  Small Biz AdvisorTests
//
//  Created by Hayley McCrory on 11/8/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import CloudKit

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
