//
//  Flag.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import CloudKit
import MagicCloud

// MARK: Protocol

protocol FlagAbstraction: MCRecordable {
    
    // !!
    var reason: FlagReason { get set }
    
    var tip: CKReference { get set }
    
    var creator: CKRecordID? { get set }
    
    var email: String { get set }
}

// MARK: - Struct

struct Flag: FlagAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: Flag !!
    
    var reason: FlagReason

    var tip: CKReference
    
    var creator = MCUserRecord().singleton
    
    var email: String = "empty"
    
    // MARK: - Properties: MCRecordable
    
    fileprivate var _recordID: CKRecordID?
 
    fileprivate let dummyRec = CKRecordID(recordName: "FLAG_ERROR")
    
    // MARK: - Functions
    
    // MARK: - Functions: Constructors
    
    init() {
        reason = .offTopic
        tip = CKReference(recordID: Tip().recordID, action: .deleteSelf)
    }
    
    init(tip: Tip, for reason: FlagReason) {
        let ref = CKReference(recordID: tip.recordID, action: .deleteSelf)
        self.tip = ref
        
        self.reason = reason
        
        self._recordID = CKRecordID(recordName: "FLAGGED: \(tip.recordID.recordName) CUZ: \(reason.toStr())")
    }
}

// MARK: - Extensions

extension Flag: MCRecordable {
    var recordType: String { return RecordType.flag }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dictionary = [String: CKRecordValue]()
            
            let reasons = reason.cloudValues
            dictionary[RecordKey.rea0] = reasons.0
            dictionary[RecordKey.rea1] = reasons.1
            
            dictionary[RecordKey.crtr] = CKReference(recordID: creator ?? MCUserRecord().singleton ?? dummyRec, action: .deleteSelf)
            dictionary[RecordKey.refs] = tip
            
            dictionary[RecordKey.mail] = email as CKRecordValue
            
            return dictionary
        }
        
        set {
            if let num = newValue[RecordKey.rea0] as? NSNumber {
                switch num.intValue {
                case 0: reason = .offTopic
                case 1: reason = .inaccurate
                case 2:
                    if let ref = newValue[RecordKey.rea1] as? CKReference { reason = .duplicate(ref) }
                case 3:
                    if let ref = newValue[RecordKey.rea1] as? CKReference { reason = .wrongCategory(ref) }
                case 4: reason = .spam
                case 5: reason = .abusive
                default: break              // <-- Value out of range...
                }
            }
            
            if let str = newValue[RecordKey.mail] as? String      { email = str }
            if let ref = newValue[RecordKey.crtr] as? CKReference { creator = ref.recordID }
            if let ref = newValue[RecordKey.refs] as? CKReference { tip = ref }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set { _recordID = newValue }
    }
}


