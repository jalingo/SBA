//
//  TipCategory.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/26/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import UIKit

enum TipCategory: Int {
    case planning = 0, organization, marketing, operations, technology, value, efficiency, fiscal, hr, security, legal
    case outOfRange = -1
    
    static let max = TipCategory.legal.rawValue + 1
    
    var indexRange: CountableClosedRange<Int> {   // <-- May need to become CountableClosedRange if iteration needed
        
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
    
    var bold: NSAttributedString {
        let bold = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        var text: String
        
        switch self {
        case .planning:     text = "Planning"
        case .organization: text = "Organization"
        case .marketing:    text = "Marketing"
        case .operations:   text = "Operation"
        case .technology:   text = "Technology"
        case .value:        text = "Value"
        case .efficiency:   text = "Efficiency"
        case .fiscal:       text = "Fiscal"
        case .hr:           text = "Human Resources"
        case .security:     text = "Security"
        case .legal:        text = "Legal"
            
        case .outOfRange:   text = "Error"
        }
        
        return NSAttributedString(string: text, attributes: bold)
    }
}

protocol CategoryFactory {
    static func produceByIndex(index: Int) -> TipCategory
}

struct TipCategoryFactory: CategoryFactory {
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
