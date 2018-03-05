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
    
    static let defaultText = UserFacingText.networkIssueInstructions
    
    // MARK: - Properties: Entry
    
    /// This property stores a formatted version of the entry's text.
    var text: NSAttributedString

    /// This property stores an enumeration of the entry's category.
    var category: TipCategory
    
    /// This property stores an unique index associated with the entry text.
    var index: Int
    
    // MARK: - Properties: Recordable
    
    /// This property acts as storage for `recordID` computed property.
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
        self.index = integer
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

/**
    The MCRecordable protocol ensures that any conforming instances have what is necessary
    to be recorded in the cloud database. Conformance to this protocol is also necessary
    to interact with the Magic Cloud framework.
 */
extension Tip: MCRecordable {
    
    // MARK: - Properties: Recordable
    
    /**
        This is a token used with cloudkit to build CKRecordID for this object's CKRecord.
     */
    var recordType: String { return RecordType.entry }
    
    /**
        This dictionary has to match all of the keys used in CKRecord in order for version
        conflicts and retry attempts to succeed. Its values should match the associated
        fields in CKRecord.
     */
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dictionary = [String: CKRecordValue]()
            
            dictionary[RecordKey.Entry.indx] = self.index as CKRecordValue
            dictionary[RecordKey.Entry.text] = self.text.string as CKRecordValue
            dictionary[RecordKey.Entry.catg] = self.category.rawValue as CKRecordValue
            
            return dictionary
        }
        set {
            if let num = newValue[RecordKey.Entry.indx] as? NSNumber { self.index = num.intValue }
            if let txt = newValue[RecordKey.Entry.text] as? String { self.text = NSAttributedString(string: txt, attributes: Format.bodyText) }
            if let num = newValue[RecordKey.Entry.catg] as? NSNumber {
                if let category = TipCategory(rawValue: num.intValue) { self.category = category }
            }
        }
    }
    
    /**
        A record identifier used to store and recover conforming instance's record. This ID is
        used to construct records and references, as well as query and fetch from the cloud
        database.
     
        - Warning: Must be unique in the database.
     */
    var recordID: CKRecordID {
        get { return _recordID ?? CKRecordID(recordName: "Tip #\(index)") }
        set(newValue) { _recordID = newValue }
    }

    /// This init w/out parameters creates an empty recordable that can be overwritten by `prepare(from:)`.
    init() {
        self.text = NSAttributedString(string: Tip.defaultText, attributes: Format.bodyText)
        self.category = .outOfRange
        self.index = -1
    }    
}


