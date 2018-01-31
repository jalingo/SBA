//
//  Vote.swift
//  Small Biz Advisor
//
//  Created by Hayley McCrory on 11/18/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import CloudKit
import MagicCloud

// MARK: Protocol

/// Votes track the for
protocol VoteAbstraction: MCRecordable {
    
    /// This property stores the direction vote was cast: for (true) or against (false).
    var isFor: Bool { get set }
    
    /// This property stores the tip that vote was cast for.
    var candidate: CKReference { get set }
    
    /// This property stores the voter that cast the ballot.
    var constituent: CKReference { get set }
}

// MARK: - Struct

struct Vote: VoteAbstraction {
    
    // MARK: - Properties
    
    // MARK: - Properties: VoteAbstraction
    
    var isFor = true
    
    /// This optional property serves as storage for computed property candidate.
    fileprivate var ballotMeasure = CKRecordID(recordName: "\(-1)")
    
    var candidate: CKReference {
        get { return CKReference(recordID: ballotMeasure, action: .deleteSelf) }
        set { ballotMeasure = newValue.recordID }
    }

    /// This optional property serves as storage for computed property constituent.
    fileprivate var voterID = MCUserRecord().singleton

    var constituent: CKReference {
        get {
            let id: CKRecordID
            voterID == nil ?
                (id = CKRecordID(recordName: "Credential Failed")) : (id = voterID!)

            return CKReference(recordID: id, action: .deleteSelf)
        }
        set { voterID = newValue.recordID }
    }
    
    // MARK: - Properties: Recordable
    
    var recordType: String = RecordType.vote
    
    var recordFields: Dictionary<String, CKRecordValue> {
        get {
            var dictionary = Dictionary<String, CKRecordValue>()
            
            dictionary[RecordKey.appr] = isFor as CKRecordValue
            dictionary[RecordKey.subj] = candidate as CKRecordValue
            dictionary[RecordKey.votr] = constituent as CKRecordValue
            
            return dictionary
        }
        
        set {
            if let bool = newValue[RecordKey.appr] as? Bool { isFor = bool }
            if let ref  = newValue[RecordKey.subj] as? CKReference { candidate = ref }
            if let ref  = newValue[RecordKey.votr] as? CKReference { constituent = ref }
        }
    }
    
    var recordID = CKRecordID(recordName: "Vote: \(Date())")
    
    // MARK: - Functions
    
    init() {
        self.isFor = true
        
        let defaultCandidate = CKRecordID(recordName: "DefaultCandidate")
        self.candidate = CKReference(recordID: defaultCandidate, action: .deleteSelf)
        
        let defaultConstituent = CKRecordID(recordName: "DefaultConstituent")
        self.constituent = CKReference(recordID: defaultConstituent, action: .deleteSelf)
    }
    
    /**
        - Parameters:
            - direction: If true, vote is for candidate. Else, vote is against.
            - subject: The reference for database record being voted for / against.
            - voter: The reference for database record associated with vote caster.
     */
    init(up direction: Bool, candidate subject: CKReference, constituent voter: CKReference) {
        self.isFor = direction
        self.candidate = subject
        self.constituent = voter
    }
}

extension Vote: Equatable {
    static func ==(lhs: Vote, rhs: Vote) -> Bool {
        return lhs.candidate.isEqual(rhs.candidate) && lhs.constituent.isEqual(rhs.constituent)
    }
}
