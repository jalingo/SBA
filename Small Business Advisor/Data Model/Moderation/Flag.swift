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

struct Flag: FlagAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: Flag
    
    var reason: FlagReason = .offTopic
    var tip: CKReference = CKReference(recordID: Tip().recordID, action: .deleteSelf)
    var creator = MCUserRecord().singleton
    
    // MARK: - Properties: MCRecordable
    
    fileprivate var _recordID: CKRecordID?
    fileprivate let dummyRec = CKRecordID(recordName: "FLAG_ERROR")
    fileprivate let reasonKey = "Flag_Reason"
    fileprivate let reasonAux = "Flag_Reason_Auxiliary"
    fileprivate let creatorKey = "Flag_Creator"
    fileprivate let tipKey = "Flag_Tip"
}

extension Flag: MCRecordable {
    var recordType: String { return "Flag" }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dictionary = [String: CKRecordValue]()
            
            let reasons = reason.cloudValues
            dictionary[reasonKey] = reasons.0
            dictionary[reasonAux] = reasons.1
            
            dictionary[creatorKey] = CKReference(recordID: creator ?? MCUserRecord().singleton ?? dummyRec, action: .deleteSelf)
            dictionary[tipKey] = tip
            
            return dictionary
        }
        
        set {
            if let num = newValue[reasonKey] as? NSNumber {
                switch num.intValue {
                case 0: reason = .offTopic
                case 1: reason = .inaccurate
                case 2:
                    if let ref = newValue[reasonAux] as? CKReference { reason = .duplicate(ref) }
                case 3:
                    if let ref = newValue[reasonAux] as? CKReference { reason = .wrongCategory(ref) }
                case 4: reason = .spam
                case 5: reason = .abusive
                default: break              // <-- Value out of range...
                }
            }
            
            if let ref = newValue[creatorKey] as? CKReference { creator = ref.recordID }
            if let ref = newValue[tipKey] as? CKReference { tip = ref }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set { _recordID = newValue }
    }
}

protocol FlagAbstraction: MCRecordable {
    var reason: FlagReason { get set }
    var tip: CKReference { get set }
    var creator: CKRecordID? { get set }
}

enum FlagReason {
    case offTopic, inaccurate, duplicate(CKReference), wrongCategory(CKReference), spam, abusive
    
    var cloudValues: (CKRecordValue, CKRecordValue?) {
        switch self {
        case .offTopic:     return (0 as CKRecordValue, nil)
        case .inaccurate:   return (1 as CKRecordValue, nil)
        case .duplicate(let tip):
            return (2 as CKRecordValue, tip)
        case .wrongCategory(let category):
            return (3 as CKRecordValue, category)
        case .spam:         return (4 as CKRecordValue, nil)
        case .abusive:      return (5 as CKRecordValue, nil)
        }
    }
}
