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
    
    /// This property stores a formatted version of the entry's text.
    var text: NSAttributedString

    /// This property stores an enumeration of the entry's category.
    var category: TipCategory
    
    /// This property storea an unique index associated with the entry text.
    var index: Int
    
    /// !! Not saved in database
    var score: Int = 0
    
    // MARK: - Properties: Recordable
    
    /// !!
    fileprivate var _recordID: CKRecordID?
    
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

// MARK: - Extension: Equatable

extension Tip: Equatable {
    static func ==(left: Tip, right: Tip) -> Bool { return left.index == right.index }
}

// MARK: - Extension: Hashable

extension Tip: Hashable {
    var hashValue: Int { return index }
}

// MARK: - Extension: Recordable

/// !!
extension Tip: MCRecordable {
    
    // MARK: - Properties: Recordable
    
    var recordType: String { return RecordType.entry }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dictionary = [String: CKRecordValue]()
            
            dictionary[RecordKey.indx] = self.index as CKRecordValue
            dictionary[RecordKey.text] = self.text.string as CKRecordValue
            dictionary[RecordKey.catg] = self.category.rawValue as CKRecordValue
            
            return dictionary
        }
        set {
            if let num = newValue[RecordKey.indx] as? NSNumber { self.index = num.intValue }
            if let txt = newValue[RecordKey.text] as? String { self.text = NSAttributedString(string: txt) }
            if let num = newValue[RecordKey.catg] as? NSNumber {
                if let category = TipCategory(rawValue: num.intValue) { self.category = category }
            }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? CKRecordID(recordName: "Tip #\(index)") }
        set(newValue) { _recordID = newValue }
    }
    
    init() {
        self.text = NSAttributedString(string: "blank text")
        self.category = .outOfRange
        self.index = -1
    }    
}

