//
//  TipCategoryConverter.swift
//  SBAdmin
//
//  Created by James Lingo on 3/9/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import Foundation

protocol TipCategoryConverter { }

extension TipCategoryConverter {
    func convert(from str: String) -> TipCategory {
        for raw in 0...TipCategory.max {
            if let cat = TipCategory(rawValue: raw), str == cat.formatted.string { return cat }
        }
        
        /* !! could check for create new here... */

        return .outOfRange
    }
}
