//
//  MCRecordable.swift
//  MagicCloud
//
//  Created by Jimmy Lingo on 8/31/16.
//  Copyright © 2016 Escape Chaos. All rights reserved.
//

import CloudKit

// MARK: - Protocol: Recordable

/**
    The MCRecordable protocol ensures that any conforming instances have what is necessary
    to be recorded in the cloud database. Conformance to this protocol is also necessary
    to interact with the Magic Cloud framework.
 */
public protocol MCRecordable {
    
    /**
        This is a token used with cloudkit to build CKRecordID for this object's CKRecord.
     */
    var recordType: String { get }
    
    /**
        This dictionary has to match all of the keys used in CKRecord in order for version
        conflicts and retry attempts to succeed. Its values should match the associated
        fields in CKRecord.
     */
    var recordFields: Dictionary<String, CKRecordValue> { get set }
    
    /**
        A record identifier used to store and recover conforming instance's record. This ID is
        used to construct records and references, as well as query and fetch from the cloud
        database.
     
        - Warning: Must be unique in the database.
     */
    var recordID: CKRecordID { get set }
    
    /**
        This init w/out parameters creates an empty recordable that can be overwritten by
        `prepare(from:)` global method.
     */
    init()
}

// MARK: - Extensions

extension MCRecordable {
    
    /// Builds an appropriate recordable based on type.
    func prepare(from record: CKRecord) -> Self {
        var newFromRecord = Self()
        
        // Overwrites default recordable with data from recovered record.
        // Order of these two lines is important.
        newFromRecord.recordID = record.recordID
        for (key, _) in newFromRecord.recordFields { newFromRecord.recordFields[key] = record[key] }
        
        return newFromRecord
    }
}

func ==(lhs: MCRecordable, rhs: MCRecordable) -> Bool {
    return lhs.recordID.recordName == rhs.recordID.recordName
}

