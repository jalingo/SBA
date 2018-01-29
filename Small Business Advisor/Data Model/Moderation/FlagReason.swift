//
//  FlagReason.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/17/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import CloudKit

/**
    An enumeration of the criteria for which a USER has flagged tip.

    - Off Topic: Said tip is not actually small business advice, but instead concerns something besides small business advice.
    - Inaccurate: Said tip contains, relies on or expounds false information.
    - Duplicate: Said tip is already better represented by another tip, or presents an existing tip redundantly.
    - Wrong Category: Said tip has been mis-categorized.
    - Spam: Said tip's purpose is to advertise or solicit, rather than actually profer advice.
    - Abusive / Obscene: Said tip contains NSFW content, or its purpose is to generate controversy, cause harm or be pornographic.
 */
enum FlagReason {
    
    // MARK: - Cases
    
    case offTopic, inaccurate, duplicate(CKReference), wrongCategory(CKReference), spam, abusive
    
    // MARK: - Properties
    
    /// This read-only, computed property returns a tuple of cloud values representing a primary reason (tuple index 0) and where necessary an auxiliary reason (tuple index 1).
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
    
    /// This static constant returns the number of possible reasons enumerated by the FlagReason type.
    static let count = 6
    
    // MARK: - Functions
    
    /// This method returns enumeration as a string.
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
