//
//  TipCategory.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/26/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import UIKit
import MagicCloud
import CloudKit

// MARK: Enum

/**
    This enumerates the different categories of tips that exist.
 
    - Planning: Tips that concern preparing and designing a business strategy and plan.
    - Organization: Tips that concern structuring administration and tasks for clarity.
    - Marketing: Tips that concern marketing research, planning and campaigns.
    - Operations: Tips that concern the operational aspects of a business.
    - Technology: Tips that concern software and web services.
    - Value: Tips that concern creating, defining and maximizing value.
    - Efficiency: Tips that concern structuring transactions and workflows for maximized productivity.
    - Fiscal: Tips that concern accounting, financial and monetary issues.
    - HR: TIps that concern ethics and human resources.
    - Security: TIps that concern securing intellectual property and client information.
    - Legal: TIps that concern regulations and legislative issues.
 
    - OutOfRange: This enumeration represents an error.
 */
enum TipCategory: Int {

    case planning = 0, organization, marketing, operations, technology, value, efficiency, fiscal, hr, security, legal
    case outOfRange = -1
    
    /// This static constant property returns the total number of categories.
    static let max = TipCategory.legal.rawValue + 1     // <-- If legal is no longer last in the case order, change!
    
    /// This computed property returns the range of tip indices associated with each category.
    var indexRange: CountableClosedRange<Int> {   
        
        switch self {
        case .planning:     return  1...23
        case .organization: return 24...28
        case .marketing:    return 29...45
        case .operations:   return 46...50
        case .technology:   return 51...61
        case .value:        return 62...65
        case .efficiency:   return 66...70
        case .fiscal:       return 71...89
        case .hr:           return 90...95
        case .security:     return 96...99
        case .legal:        return 100...105

        case .outOfRange:   return 0...0
        }
    }
    
    /// This computed property returns the title of each category as a string, with formatting.
    var formatted: NSMutableAttributedString {
        var text: String
        
        switch self {
        case .planning:     text = "Planning"
        case .organization: text = "Organization"
        case .marketing:    text = "Marketing"
        case .operations:   text = "Operations"
        case .technology:   text = "Technology"
        case .value:        text = "Value"
        case .efficiency:   text = "Efficiency"
        case .fiscal:       text = "Fiscal"
        case .hr:           text = "Human Resources"
        case .security:     text = "Security"
        case .legal:        text = "Legal"
            
        case .outOfRange:   text = "Error"
        }
        
        return NSMutableAttributedString(string: text, attributes: Format.categoryTitle)
    }
}

/// This protocol ensures conforming instances can produce a specified `TipCategory`.
protocol CategoryFactory {
    static func produceByIndex(index: Int) -> TipCategory
}

/// This struct conforming to `CategoryFactory` produces a specified `TipCategory`.
struct TipCategoryFactory: CategoryFactory {
    
    /**
        This static func creates a TipCategory based on specified index.
     
        - Parameter index: An integer reflecting the unique identifier for a tip in TipCategory.
        - Returns: The TipCategory for the specified index.
     */
    static func produceByIndex(index: Int) -> TipCategory {
        switch index {
        case TipCategory.planning.indexRange:       return .planning
        case TipCategory.organization.indexRange:   return .organization
        case TipCategory.marketing.indexRange:      return .marketing
        case TipCategory.operations.indexRange:     return .operations
        case TipCategory.technology.indexRange:     return .technology
        case TipCategory.value.indexRange:          return .value
        case TipCategory.efficiency.indexRange:     return .efficiency
        case TipCategory.fiscal.indexRange:         return .fiscal
        case TipCategory.hr.indexRange:             return .hr
        case TipCategory.security.indexRange:       return .security
        case TipCategory.legal.indexRange:          return .legal
        default:                                    return .outOfRange
        }
    }
}

// MARK: - Extensions

// MARK: - Extension: MCRecordable

extension TipCategory: MCRecordable {

    var recordType: String { return RecordType.category }

    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var d = Dictionary<String, CKRecordValue>()
            d[RecordKey.Entry.catg] = NSNumber(value: self.rawValue)
            
            return d
        }
        
        set {
            if let num = newValue[RecordKey.Entry.catg] as? NSNumber, let value = TipCategory(rawValue: num.intValue) { self = value }
        }
    }
    
    var recordID: CKRecordID {
        get { return CKRecordID(recordName: self.formatted.string) }
        set { }
    }
    
    init() { self = .outOfRange }
}
