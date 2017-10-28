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

struct TipFactory: EntryFactory {
    
    static let max = 105
    
    static func produceByIndex(index integer: Int) -> Entry {
        return MockTip(index: integer, category: TipCategoryFactory.produceByIndex(index: integer), text: "Test")
    }
    
    static func produceByRandom() -> Entry {
        let random = Int(arc4random_uniform(UInt32(self.max)))
        return MockTip(index: random, category: TipCategoryFactory.produceByIndex(index: random), text: "Test")
    }
}

protocol Entry {
    
    var text: String { get }
    
    var category: TipCategory { get }
    
    var index: Int { get }
    
    // The following two methods aren't strictly necessary, except that they force all Entry's to be Equatable (preventing a non-equatable from being wrapped).
    // Conforming to equatable will allow confoming to these without implementing, through Entry extension.
    
    func asEquatable() -> AnyEntry
    
    func isEqualTo(entry: Entry) -> Bool
}

// Extension that provides tools for AnyEntry wrapper.
// Any Entry conforming to Equatable, will automatically inherent these conformances.
extension Entry where Self: Equatable {
    
    func isEqualTo(entry: Entry) -> Bool {
        guard let other = entry as? Self else { return false }
        return self.index == other.index
    }
    
    func asEquatable() -> AnyEntry { return AnyEntry(entry: self) }
}

// Wrapper whose purpose is Equatable conformance.
struct AnyEntry: Entry {
    
    // MARK: - Properties
    
    let wrappedEntry: Entry
    
    var text: String { return wrappedEntry.text }
    
    var category: TipCategory { return wrappedEntry.category }
    
    var index: Int { return wrappedEntry.index }
    
    // MARK: - Functions
    
    func asEntry() -> Entry { return wrappedEntry }
    
    init(entry: Entry) { wrappedEntry = entry }
}

extension AnyEntry: Equatable {
    static func ==(left: AnyEntry, right: AnyEntry) -> Bool { return left.isEqualTo(entry: right) }
}
