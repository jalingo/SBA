//
//  TipCategory.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/26/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

enum TipCategory: Int {
    case planning = 0, organization, marketing, operations, technology, value, efficiency, fiscal, hr, security, legal
    case outOfRange = -1
    
    static let Max = TipCategory.legal.rawValue + 1
}

struct TipCategoryFactory: CategoryFactory {
    func produceByIndex(index: Int) -> TipCategory { return TipCategory(rawValue: index) ?? .outOfRange }
}
