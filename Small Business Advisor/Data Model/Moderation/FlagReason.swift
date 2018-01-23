//
//  FlagReason.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/17/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import CloudKit

enum FlagReason {
    
    // MARK: - Cases
    
    case offTopic, inaccurate, duplicate(CKReference), wrongCategory(CKReference), spam, abusive
    
    // MARK: - Properties
    
    var cloudValues: (CKRecordValue, CKRecordValue?) {
        switch self {
        case .offTopic:                     return (0 as CKRecordValue, nil)
        case .inaccurate:                   return (1 as CKRecordValue, nil)
        case .duplicate(let tip):           return (2 as CKRecordValue, tip)
        case .wrongCategory(let category):  return (3 as CKRecordValue, category)
        case .spam:                         return (4 as CKRecordValue, nil)
        case .abusive:                      return (5 as CKRecordValue, nil)
        }
    }
    
    static let count = 6
    
    // MARK: - Functions
    
    func toStr() -> String {
        switch self {
        case .offTopic:                     return "Off Topic"
        case .inaccurate:                   return "Inaccurate"
        case .duplicate(let tip):           return "Duplicate of \(tip.recordID.recordName)"
        case .wrongCategory(let category):  return "Actual Category is \(category.recordID.recordName)"
        case .spam:                         return "Spam"
        case .abusive:                      return "Abusive"
        }
    }
}
