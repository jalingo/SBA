//
//  Entries.swift
//  Small Business Advisor
//
//  Created by James Lingo on 9/17/17.
//  Copyright © 2017 James Lingo. All rights reserved.
//

import Foundation

enum OldEntry {
    
    static let MAX_COUNT = 16
    
    case businessTip(Int)
    case random
    case promotional
    
    func toInt() -> Int {
        switch self {
        case .businessTip(let num): return num
        case .random:               return Int(arc4random_uniform(16))
        case .promotional:          return -1
        }
    }
    
    static func response(for entry: OldEntry) -> String {

        switch entry.toInt() {
        case 0: return "When sending e-mails, make sure to follow the four C's: Clear, Correct, Concise, and Complete."
        case 1: return "Ethical behavior in business improves the workplace climate and will ultimately improve the bottom line. The cost of unethical behavior can be staggering."
        case 2: return "Businesses must become proactive in attempting to identify the value proposition of their customers. They must know how to listen to the VOC (voice of the customer)."
        case 3: return "Focusing on customer value improves customer loyalty, which improves cash flow."
        case 4: return "CRM software was formerly so complex and expensive that it was suitable for large corporations only. Now it can be used by the smallest of businesses to improve customer value."
        case 5: return "Succession planning is critical to the success of passing a family business to family members."
        case 6: return "Small businesses are the new target for cybercrime. As a result, small businesses must pay attention to their website security because it will protect the business and influence customer trust."
        case 7: return "Forecasting is critical to the success of any business."
        case 8: return "The complexity and difficulty of building a comprehensive business plan can be significantly reduced by using one of the available business-planning software packages. Check out these sites: liveplan.com, lawdepot.com, businessplanpro.com, etc..."
        case 9: return "The planning process for a small business must always incorporate the notion of customer value and recognize that this notion can change over time."
        case 10: return "The proper management of a firm’s cash flow requires a commitment to planning for expenses proactively, and the management that requires."
        case 11: return "Customer value is the difference between perceived benefits and perceived costs. There are different types of customer value: functional, social, epistemic, emotional, and conditional."
        case 12: return "The marketing concept has guided business practice since the 1950s. Ignoring market research, planning and campaigns can be perilous."
        case 13: return "Strategy identifies how a firm will provide value to its customers within its operational constraints."
        case 14: return "Strategy can be reduced to four major approaches—cost leadership, differentiation, cost focus, and differentiation focus."
            
        default:
            return "Thanks for using the Small Business Advisor!"
        }
    }
}

