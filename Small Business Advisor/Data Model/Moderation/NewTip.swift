//
//  NewTip.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import CloudKit
import MagicCloud

//!!
protocol NewTipAbstraction: SuggestedModeration {
    var text: String { get set }
    var category: String { get set }
}

struct NewTip: NewTipAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: NewTip
    
    var text: String = "Input suggested advice here..."
    
    var category: String = TipCategory.outOfRange.formatted.string
    
    // MARK: - Properties: SuggestedModeration

    var editorEmail: String?

    var tip: CKReference = CKReference(recordID: CKRecordID(recordName: "Do NOT use..."), action: .deleteSelf)

    // MARK: - Properties: MCRecordable
    
    var _recordID: CKRecordID?
    
    fileprivate let dummyRec = CKRecordID(recordName: "NEWTIP_ERROR")
    
    // MARK: - Functions
    
    // MARK: - Functions: Constructors

    init() { /* This init creates a dummy record used by MCRecordable for replication. */ }
    
    init(text txt: String, category cat: String) {
        _recordID = CKRecordID(recordName: "New@\(Date().description)")
        
        text = txt
        category = cat
    }
}

extension NewTip: MCRecordable {
    
    var recordType: String { return RecordType.newt }
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dict = [String: CKRecordValue]()
            
            dict[RecordKey.ntxt] = text     as CKRecordValue
            dict[RecordKey.ncat] = category as CKRecordValue
            
            return dict
        }
        set {
            if let txt = newValue[RecordKey.ntxt] as? String { text = txt }
            if let txt = newValue[RecordKey.ncat] as? String { category = txt }
        }
    }
    
    var recordID: CKRecordID {
        get { return _recordID ?? dummyRec }
        set { _recordID = newValue }
    }
}
