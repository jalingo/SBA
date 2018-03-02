//
//  NewTip.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import CloudKit
import MagicCloud

/// This abstraction of NewTip functionality ensures this form of moderation contains properties that match necessary dependencies for potential Tip to be created.
protocol NewTipAbstraction: SuggestedModeration {

    /// This property stores the textual representation of advice that would be embodied in the potential tip.
    var text: String { get set }

    /// This property stores a string representation of the categorical type that encompasses the potential tip.
    var category: String { get set }
}

/// This concrete sub class of NewTip abstraction creates instances of NewTip's that can be saved as records in the database.
struct NewTip: NewTipAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: NewTip
    
    var text: String = "Input suggested advice here..."
    
    var category: String = TipCategory.outOfRange.formatted.string
    
    // MARK: - Properties: SuggestedModeration

    var editorEmail: String?

    var tip: CKReference = CKReference(recordID: CKRecordID(recordName: "Do NOT use..."), action: .deleteSelf)

    var creator: CKRecordID?
    
    var state: ModerationState = .submitted
    
    static var limit: Int? = 5
    
    // MARK: - Properties: MCRecordable
    
    /// This property acts as storage for `recordID` computed property.
    var _recordID: CKRecordID?
    
    /// This default record is only returned when recordable has not been properly configured.
    fileprivate let dummyRec = CKRecordID(recordName: "NEWTIP_ERROR")
    
    // MARK: - Functions
    
    // MARK: - Functions: Constructors

    init() { /* This init creates a dummy record used by MCRecordable for replication. */ }
    
    /**
        This concrete sub class of NewTip abstraction creates instances of NewTip's that can be saved as records in the database.

        - Parameters:
            - text: A textual representation of advice that would be embodied in the potential tip.
            - category: A string representation of the categorical type that encompasses the potential tip.
     */
    init(text txt: String, category cat: String) {
        _recordID = CKRecordID(recordName: "NEW: \(Date().description)")
        
        text = txt
        category = cat
        
        creator = MCUserRecord().singleton
    }
}

extension NewTip: MCRecordable {
    
    var recordType: String { return RecordType.newt }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dict = [String: CKRecordValue]()
            
            dict[RecordKey.ntxt] = text     as CKRecordValue
            dict[RecordKey.ncat] = category as CKRecordValue
            dict[RecordKey.crtr] = CKReference(recordID: creator ?? MCUserRecord().singleton ?? dummyRec, action: .deleteSelf)

            dict[RecordKey.stat] = state.rawValue as CKRecordValue
            if let str = editorEmail    { dict[RecordKey.mail] = str as CKRecordValue }

            return dict
        }
        
        set {
            if let num = newValue[RecordKey.stat] as? NSNumber,
                let modState = ModerationState(rawValue: num.intValue) { state = modState }
            if let txt = newValue[RecordKey.ntxt] as? String { text = txt }
            if let txt = newValue[RecordKey.ncat] as? String { category = txt }
            if let ref = newValue[RecordKey.crtr] as? CKReference { creator = ref.recordID }
            if let ref = newValue[RecordKey.crtr] as? CKReference { creator = ref.recordID }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set { _recordID = newValue }
    }
}
