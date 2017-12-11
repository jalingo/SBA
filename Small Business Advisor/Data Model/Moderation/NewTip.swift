//
//  NewTip.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import CloudKit
import MagicCloud

protocol NewTipAbstraction: MCRecordable {
    var text: String { get set }
    var category: String { get set }
}

struct NewTip: NewTipAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: NewTip
    
    var text: String = "Input suggested advice here..."
    
    var category: String = TipCategory.outOfRange.formatted.string
    
    // MARK: - Properties: MCRecordable
    
    var _recordID: CKRecordID?
    
    fileprivate let dummyRec = CKRecordID(recordName: "NEWTIP_ERROR")
    
    let txtKey = "NewTip_Text"
    
    let catKey = "NewTip_Category"
}

extension NewTip: MCRecordable {
    var recordType: String { return "New_Tip_Suggestion" }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dict = [String: CKRecordValue]()
            
            dict[txtKey] = text     as CKRecordValue
            dict[catKey] = category as CKRecordValue
            
            return dict
        }
        set {
            if let txt = newValue[txtKey] as? String { text = txt }
            if let txt = newValue[catKey] as? String { category = txt }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set { _recordID = newValue }
    }
}
