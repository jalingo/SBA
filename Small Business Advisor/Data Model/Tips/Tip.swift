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
            
            dictionary[RecordKey.indx] = self.index as CKRecordValue
            dictionary[RecordKey.text] = self.text.string as CKRecordValue
            dictionary[RecordKey.catg] = self.category.rawValue as CKRecordValue
            
            return dictionary
        }
        set {
            if let num = newValue[RecordKey.indx] as? NSNumber { self.index = num.intValue }
            if let txt = newValue[RecordKey.text] as? String { self.text = NSAttributedString(string: txt, attributes: BodyTextFormatting()) }
            if let num = newValue[RecordKey.catg] as? NSNumber {
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
        self.text = NSAttributedString(string: "blank text", attributes: BodyTextFormatting())
        self.category = .outOfRange
        self.index = -1
    }    
}

/// This global method provides the formatting for attributed strings representing entry text.
func BodyTextFormatting() -> [NSAttributedStringKey : NSObject] {
    
    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    
    let formatting = [
        NSAttributedStringKey.font :            UIFont.boldSystemFont(ofSize: 18),
        NSAttributedStringKey.foregroundColor:  UIColor(red: 0.55, green: 0.78, blue: 0.25, alpha: 1.0)
    ]
    
    return formatting
}
