//
//  TipText.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/27/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

protocol StringFactory {
    static var max: Int { get }
    
    static func produce(for index: Int) -> String
}

struct TextFactory: StringFactory {
    
    static var max = 105   // <-- Eventually these will have to calculate dynamic totals...
    
    static func produce(for index: Int) -> String {
        switch index {
        case ..<1:      return "\(1)"
        case 1..<105:   return "\(index)"
        default:        return "\(105)"
        }
    }
}
