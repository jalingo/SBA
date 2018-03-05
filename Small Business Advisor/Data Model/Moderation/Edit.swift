//
//  Edit.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import MagicCloud
import CloudKit

/// This abstraction of Edit functionality ensures this form of moderation contains properties that match Tip properties that can be modified.
protocol EditAbstraction: SuggestedModeration {

    /// This optional property can store changes to tip body text which USER is modifying.
    var newText: String? { get set }

    /// This optional property can store changes to tip category which USER is modifying.
    var newCategory: String? { get set }
}

/// This concrete sub class of Edit abstraction creates instances of Edit's that can be saved as records in the database.
struct TipEdit: EditAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: EditAbstraction
    
    var newText: String?
    
    var newCategory: String?
    
    // MARK: - Properties: SuggestedModeration
    
    var tip: CKReference
    
    var editorEmail: String?
    
    var creator: CKRecordID?
    
    var state: ModerationState = .submitted
    
    static var limit: Int? = 5
    
    // MARK: - Properties: MCRecordable
    
    /// This property acts as storage for `recordID` computed property.
    var _recordID: CKRecordID?
    
    /// This default record is only returned when recordable has not been properly configured.
    fileprivate let dummyRec = CKRecordID(recordName: "EDIT_ERROR")
    
    // MARK: - Functions
    
    // MARK: - Functions: Construction
    
    init() { tip = CKReference(recordID: dummyRec, action: .deleteSelf) }
    
    /**
        This concrete sub class of Edit abstraction creates instances of Edit's that can be saved as records in the database.
     
        - Parameters:
            - newText: A textual representation of advice that would be embodied in editedTip, containing any modifications or revisions made by the USER.
            - newCategory: A string representation of the new categorical type being suggested by the USER for editedTip.
            - editedTip: The subject suggested moderation concerns.
     */
    init(newText str: String?, newCategory cat: String?, for editedTip: Tip) {
        newText = str
        newCategory = cat
        tip = CKReference(recordID: editedTip.recordID, action: .deleteSelf)
        
        recordID = CKRecordID(recordName: "EDIT: \(editedTip.recordID.recordName)")
        creator = MCUserRecord().singleton
    }
}

extension TipEdit: MCRecordable {
    
    var recordType: String { return RecordType.edit }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dict = [String: CKRecordValue]()
            
            if let txt = newText        { dict[RecordKey.Suggestion.ntxt] = txt as CKRecordValue }
            if let str = newCategory    { dict[RecordKey.Suggestion.ncat] = str as CKRecordValue }

            if let str = editorEmail    { dict[RecordKey.Suggestion.mail] = str as CKRecordValue }
            dict[RecordKey.Suggestion.stat] = state.rawValue as CKRecordValue
            
            dict[RecordKey.Suggestion.crtr] = CKReference(recordID: creator ?? MCUserRecord().singleton ?? dummyRec, action: .deleteSelf)
            dict[RecordKey.refs] = tip
            
            return dict
        }
        
        set {
            if let ref = newValue[RecordKey.refs] as? CKReference { tip = ref }
            if let txt = newValue[RecordKey.Suggestion.ntxt] as? String      { newText = txt }
            if let str = newValue[RecordKey.Suggestion.ncat] as? String      { newCategory = str }
            if let str = newValue[RecordKey.Suggestion.mail] as? String      { editorEmail = str }
            if let num = newValue[RecordKey.Suggestion.stat] as? NSNumber,
                let modState = ModerationState(rawValue: num.intValue) { state = modState }
            if let ref = newValue[RecordKey.Suggestion.crtr] as? CKReference { creator = ref.recordID }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set(newValue) { _recordID = newValue }
    }
}
