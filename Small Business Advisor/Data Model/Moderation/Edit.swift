//
//  Edit.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import MagicCloud
import CloudKit

// !!
protocol EditAbstraction: SuggestedModeration {
    var newText: String? { get set }
    var newCategory: String? { get set }
    var tip: CKReference { get set }
}

struct TipEdit: EditAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: EditAbstraction
    
    var newText: String?
    
    var newCategory: String?
    
    // MARK: - Properties: SuggestedModeration
    
    var tip: CKReference
    
    var editorEmail: String?
    
    // MARK: - Properties: MCRecordable
    
    var _recordID: CKRecordID?
    
    fileprivate let dummyRec = CKRecordID(recordName: "EDIT_ERROR")
    
    // MARK: - Functions
    
    // MARK: - Functions: Construction
    
    init() { tip = CKReference(recordID: dummyRec, action: .deleteSelf) }
    
    init(newText str: String?, newCategory cat: String?, for editedTip: Tip) {
        newText = str
        newCategory = cat
        tip = CKReference(recordID: editedTip.recordID, action: .deleteSelf)
        
        recordID = CKRecordID(recordName: "EDIT: \(editedTip.recordID.recordName)")
    }
}

extension TipEdit: MCRecordable {
    
    var recordType: String { return RecordType.edit }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dict = [String: CKRecordValue]()
            
            if let txt = newText        { dict[RecordKey.ntxt] = txt as CKRecordValue }
            if let str = newCategory    { dict[RecordKey.ncat] = str as CKRecordValue }
            dict[RecordKey.refs] = tip
            
            return dict
        }
        set {
            if let ref = newValue[RecordKey.refs] as? CKReference { tip = ref }
            if let txt = newValue[RecordKey.ntxt] as? String      { newText = txt }
            if let str = newValue[RecordKey.ncat] as? String      { newCategory = str }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set(newValue) { _recordID = newValue }
    }
}

protocol SuggestedModeration {
    var editorEmail: String? { get set }
    var tip: CKReference     { get set }
}
