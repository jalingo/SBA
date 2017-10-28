//
//  Entry.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/28/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

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
