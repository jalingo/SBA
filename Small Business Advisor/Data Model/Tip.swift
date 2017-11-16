//
//  Tip.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/27/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import MagicCloud
import CloudKit

// Conforms to `Entry` protocol (see 'Entry.swift').

// MARK: Struct

/**
    This struct is the core implementation of the Entry protocol.
 
    If the user interface becomes more complex, individual viewControllers may adopt the Entry protocol, at which
    point this implementation may need to be deprecated.
 */
struct Tip: Entry {
    
    // MARK: - Properties
    
    /// This constant property stores a formatted version of the entry's text.
    let text: NSAttributedString

    /// This constant property stores an enumeration of the entry's category.
    let category: TipCategory
    
    /// This constant property storea an unique index associated with the entry text.
    let index: Int
    
    // MARK: - Properties: Recordable
    
    var _recordID: CKRecordID?
    
    // MARK: - Functions

    /**
        - Parameters:
         - index: A unique numerical identifier associated with the entry's text. If out of range, corrected.
         - category: An enumeration of the category entry is associated with.
         - text: The entry's primary data, as a formatted string.
     */
    init(index integer: Int, category cat: TipCategory, text str: NSAttributedString) {
        self.category = cat
        self.text = str
        
        // These two lines keep the indexes constrained to range: 0 - max
        guard integer < TipFactory.max else { self.index = 105; return }
        integer > 0 ? (self.index = integer) : (self.index = 1)
    }
}

// MARK: - Extensions

// MARK: Extension: Equatable

extension Tip: Equatable {
    static func ==(left: Tip, right: Tip) -> Bool { return left.index == right.index }
}

// MARK: - Extension: Recordable

extension Tip: Recordable {
    
    // MARK: - Properties: Recordable
    
    var recordType: String { return RecordType.entry }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            <#code#>
        }
        set(newValue) {
            <#code#>
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? CKRecordID(recordName: "Tip #\(index)") }
        set(newValue) { _recordID = newValue }
    }
    
    init() {
        <#code#>
    }
    
    
}

