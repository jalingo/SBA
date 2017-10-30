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
        
        return NSMutableAttributedString(string: text, attributes: CategoryFormatting())
    }
}

protocol CategoryFactory {
    static func produceByIndex(index: Int) -> TipCategory
}

func CategoryFormatting() -> [NSAttributedStringKey: NSObject] {
    
    var shadow: NSShadow {
        let _shadow = NSShadow()
        
        _shadow.shadowBlurRadius = 2
        _shadow.shadowOffset = CGSize(width: 2, height: 2)
        _shadow.shadowColor = UIColor.darkGray
        
        return _shadow
    }
    
    let formatting = [
        NSAttributedStringKey.font :            UIFont.boldSystemFont(ofSize: 24),
        NSAttributedStringKey.foregroundColor:  UIColor(red: 0.55, green: 0.78, blue: 0.25, alpha: 1.0),
        NSAttributedStringKey.shadow:           shadow
    ]
    
    return formatting
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
