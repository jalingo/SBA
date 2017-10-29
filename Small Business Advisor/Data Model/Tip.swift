//
//  Tip.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/27/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

struct Tip: Entry {
    
    let text: String
    
    let category: TipCategory
    
    let index: Int
    
    init(index integer: Int, category cat: TipCategory, text str: String) {
        self.category = cat
        self.text = str
        
        integer > 0 ? (self.index = integer) : (self.index = 999999)
    }
}

extension Tip: Equatable {
    static func ==(left: Tip, right: Tip) -> Bool { return left.index == right.index }
}

protocol EntryFactory {
    
    static var max: Int { get }
    
    static func produceByIndex(index: Int) -> Entry
    
    static func produceByRandom() -> Entry
}

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