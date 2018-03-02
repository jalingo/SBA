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

/// This abstracts the concept of flagging content for removal based on a specific criterion.
protocol FlagAbstraction: SuggestedModeration {
    
    /// This property stores the criteria for which a USER has flagged tip.
    var reason: FlagReason { get set }
}

// MARK: - Struct

/// This concrete sub class of Flag abstraction creates instances of Flag's that can be saved as records in the database.
struct Flag: FlagAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: Flag
    
    var reason: FlagReason
    
    // MARK: - Properties: SuggestedModeration
    
    var tip: CKReference

    var editorEmail: String?

    var creator: CKRecordID?
    
    var state: ModerationState = .submitted
    
    static var limit: Int? = 3
    
    // MARK: - Properties: MCRecordable
    
    /// This property acts as storage for `recordID` computed property.
    fileprivate var _recordID: CKRecordID?
 
    /// This default record is only returned when recordable has not been properly configured.
    fileprivate let dummyRec = CKRecordID(recordName: "FLAG_ERROR")
    
    // MARK: - Functions
    
    // MARK: - Functions: Constructors
    
    init() {
        reason = .offTopic
        tip = CKReference(recordID: Tip().recordID, action: .deleteSelf)
    }
    
    /**
        This concrete sub class of Flag abstraction creates instances of Flag's that can be saved as records in the database.
     
        - Parameters:
            - tip: The subject suggested moderation concerns.
            - reason: The criteria for which a USER has flagged tip.
     */
    init(tip: Tip, for reason: FlagReason) {
        let ref = CKReference(recordID: tip.recordID, action: .deleteSelf)
        self.tip = ref
        
        self.reason = reason
        
        creator = MCUserRecord().singleton
        self._recordID = CKRecordID(recordName: "FLAG: \(tip.recordID.recordName) CUZ: \(reason.toStr())")
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
            
            dictionary[RecordKey.stat] = state.rawValue as CKRecordValue
            if let str = editorEmail { dictionary[RecordKey.mail] = str as CKRecordValue }

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
            
            if let num = newValue[RecordKey.stat] as? NSNumber,
                let modState = ModerationState(rawValue: num.intValue) { state = modState }
            if let str = newValue[RecordKey.mail] as? String      { editorEmail = str }
            if let ref = newValue[RecordKey.crtr] as? CKReference { creator = ref.recordID }
            if let ref = newValue[RecordKey.refs] as? CKReference { tip = ref }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set { _recordID = newValue }
    }
}


