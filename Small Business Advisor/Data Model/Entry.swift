//
//  Entry.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/28/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

// MARK: Protocol

/**
    This protocol defines the core unit of the data model as a list entry that has a category, text and index.
 
    Corresponding methods allow for conforming instances to be Equatable, without associating types at current
    level of abstraction. See extension constrained by `Equatable` conformance below.
 
    - Warning: This pattern relies on each entry having a unique index, for easy comparisons.
 */
protocol Entry {
    
    // MARK: - Properties
    
    /// This read only property returns the actual string of text composing each entry, with formatting.
    var text: NSAttributedString { get }
    
    /// This read only property returns the category the entry's text is associated with.
    var category: TipCategory { get }

    /// This read only property returns the index used as an unique identifier for the entry's text.
    var index: Int { get }
    
    // MARK: - Functions

    /**
        This method is used to wrap conforming instance in an Equatable version used when comparing.
     
        The following method isn't strictly necessary because of the extension implementation, except that it
        forces all Entry's to be Equatable (preventing a non-equatable from being wrapped).
     
        Conforming to equatable allows automatic conformance without implementing, through Entry extension.
     
        - Warning: This pattern relies on each entry having a unique index, for easy comparisons.
     
        - Returns: A version of conforming instance inside an Equatable wrapper.
     */
    func asEquatable() -> AnyEntry

    /**
        This method is used when making comparisons, allowing for a uniform implementation of `==` requirement in
        extension constrained by `Equatable` conformance below.
     
        Currently, the existance of unique index makes implementation a simple comparison of indices, but if data
        model had to drop `index` each of these methods would need to be implemented and the `isEqualTo(entry:)`
        in the below extension needs to be removed (to force unique implementations).
     
        The following method isn't strictly necessary because of the extension implementation, except that it
        forces all Entry's to be Equatable (preventing a non-equatable from being wrapped).
     
        Conforming to equatable allows automatic conformance without implementing, through Entry extension.
     
        - Warning: This pattern relies on each entry having a unique index, for easy comparisons.
     
        - Returns: A version of conforming instance inside an Equatable wrapper.
     */
    func isEqualTo(entry: Entry) -> Bool
}

// MARK: - Protocol Extension

/**
    This extension provides tools for AnyEntry wrapper, so instances conforming to `Entry` can be compared without
    requiring type association in the protocol.

    Any Entry conforming to Equatable, will automatically inherent these conformances and their implementations.
 
    - Warning: This pattern relies on each entry having a unique index, for easy comparisons.
 */
extension Entry where Self: Equatable {
    
    /**
        This method compares any other instance conforming to `Entry` to owner, after ensuring both instances are
        same type.

        Currently, the existance of unique index makes implementation a simple comparison of indices, but if data
        model had to drop `index` each of these methods would need to be implemented and the `isEqualTo(entry:)`
        in the below extension needs to be removed (to force unique implementations).
     
        - Warning: This pattern relies on each entry having a unique index, for easy comparisons.

        - Returns: `true` when both instances share the same index, otherwise `false`.
     */
    func isEqualTo(entry: Entry) -> Bool {
        guard let other = entry as? Self else { return false }
        return self.index == other.index
    }
    
    /**
        This method is used to wrap instance in an Equatable struct, for easy comparison.
     
        Conforming to equatable allows automatic conformance without implementing, through Entry extension.
     
        - Warning: This pattern relies on each entry having a unique index, for easy comparisons.
     
        - Returns: A version of conforming instance inside an Equatable wrapper.
     */
    func asEquatable() -> AnyEntry { return AnyEntry(entry: self) }
}

// MARK: - Struct

/**
    This struct follows the wrapper design pattern, in order to allow `Equatable` conformance without forcing the
    `Entry` protocol to adopt type association.
 
    The wrapper contains the original conforming instance, and uses it's properties to make comparisons. It can
    also unwrap the original conforming instance.

    Through `Equatable` conformance, constrained `Entry` extension and it's auto conformance applies. No other
    conforming instances of Entry need `Equatable` conformance because of the wrapper.
 
    - Warning: This pattern relies on each entry having a unique index, for easy comparisons.
 */
struct AnyEntry: Entry {
    
    // MARK: - Properties
    
    /// This constant property stores the instance conforming to Entry that needs to be wrapped and compared.
    let wrappedEntry: Entry
    
    /// This computed property returns the entry text derived from `wrappedEntry`.
    var text: NSAttributedString { return wrappedEntry.text }
    
    /// This computed property returns the entry category derived from `wrappedEntry`.
    var category: TipCategory { return wrappedEntry.category }
    
    /// This computed property returns the entry category derived from `wrappedEntry`.
    var index: Int { return wrappedEntry.index }
    
    // MARK: - Functions
    
    /**
        This method unwraps the instance conforming to `Entry` stored inside the `AnyEntry` wrapper.

        - Returns: Instance conforming to `Entry` that was wrapped at initialization.
     */
    func asEntry() -> Entry { return wrappedEntry }

    /// This init method takes the argument and wraps it with `AnyEntry` to make `Equatable`.
    init(entry: Entry) { wrappedEntry = entry }
}

// MARK: - Extension

/// This extension provides for `AnyEntry` conformance to `Equatable` protocol.
extension AnyEntry: Equatable {
    static func ==(left: AnyEntry, right: AnyEntry) -> Bool { return left.isEqualTo(entry: right) }
}
