//
//  Edit.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import MagicCloud
import CloudKit

protocol EditAbstraction: MCRecordable {
    var newText: String? { get set }
    var newCategory: TipCategory? { get set }
    var tip: CKReference { get set }
}

struct TipEdit: EditAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: EditAbstraction
    
    var newText: String?
    
    var newCategory: TipCategory?
    
    var tip: CKReference
    
    // MARK: - Properties: MCRecordable
    
    var _recordID: CKRecordID?
    
    fileprivate let dummyRec = CKRecordID(recordName: "EDIT_ERROR")
    
    let txtKey = "Edit_Text"
    
    let catKey = "Edit_Category"
    
    let tipKey = "Edit_Tip"
    
    // MARK: - Functions
    
    // MARK: - Functions: Construction
    
    init() { tip = CKReference(recordID: dummyRec, action: .deleteSelf) }
}

extension TipEdit: MCRecordable {
    
    var recordType: String { return "MockEdit" }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dict = [String: CKRecordValue]()
            
            if let txt = newText        { dict[txtKey] = txt as CKRecordValue }
            if let cat = newCategory    { dict[catKey] = cat.rawValue as CKRecordValue }
            dict[tipKey] = tip
            
            return dict
        }
        set {
            if let ref = newValue[tipKey] as? CKReference { tip = ref }
            if let txt = newValue[txtKey] as? String { newText = txt }
            if let num = newValue[catKey] as? NSNumber { newCategory = TipCategory(rawValue: num.intValue) }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set(newValue) { _recordID = newValue }
    }
}
