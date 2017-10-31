//
//  TipFactory.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/31/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol EntryFactory {
    
    static var max: Int { get }
    
    static func produceByIndex(index: Int) -> Entry
    
    static func produceByRandom() -> Entry
}

// MARK: - Struct

struct TipFactory: EntryFactory {
    
    static let max = 105
    
    static func produceByIndex(index integer: Int) -> Entry {
        return Tip(index: integer, category: TipCategoryFactory.produceByIndex(index: integer), text: TextFactory.produce(for: integer))
    }
    
    static func produceByRandom() -> Entry {
        let random = Int(arc4random_uniform(UInt32(self.max)))
        return produceByIndex(index: random)
    }
}
