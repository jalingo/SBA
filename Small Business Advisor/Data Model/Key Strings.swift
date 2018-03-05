//
//  Key Strings.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 11/4/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

// MARK: CKRecordType Identifiers

/// This struct contains string identifiers for every CKRecordType represented in database schema.
struct RecordType {

    /// This static constant stores the string identifier for Tip struct's CKRecordType: "ADVISOR_ENTRY".
    static let entry = "ADVISOR_ENTRY"

    /// This static constant stores the string identifier for Vote struct's corresponding CKRecordType: "ADVISOR_VOTE".
    static let vote = "ADVISOR_VOTE"
        
    /// This static constant stores the string identifier for TipCategory enum's corresponding CKRecordType: "ADVISOR_CATEGORY".
    static let category = "ADVISOR_CATEGORY"
    
    /// This static constant stores the string identifier for Flag struct's corresponding CKRecordType: "SUGGESTED_FLAG".
    static let flag = "SUGGESTED_FLAG"
    
    /// This static constant stores the string identifier for TipEdit struct's corresponding CKRecordType: "SUGGESTED_EDIT".
    static let edit = "SUGGESTED_EDIT"
    
    /// This static constant stores the string identifier for NewTip struct's corresponding CKRecordType: "SUGGESTED_TIP".
    static let newt = "SUGGESTED_TIP"
    
    /// This static constant stores the string identifier for a mock record's corresponding CKRecordType: "MOCK_RECORD".
    /// This key should be reserved for testing database functionality.
    static let mock = "MOCK_RECORD"
}

// MARK: - CKRecord Keys

/// This struct contains keys for KV storage in CKRecord.
struct RecordKey {

    /// This inner struct contains strings used by `Entry` type.
    struct Entry {

        /// This CKRecord key matches "index: Int" value in "Tip" database record: "ENTRY_INDEX".
        static let indx = "ENTRY_INDEX"
        
        /// This CKRecord key matches "text: String" value in "Tip" database record: "ENTRY_TEXT".
        static let text = "ENTRY_TEXT"
        
        /// This CKRecord key matches "category: TipCategory" value in "Tip" database record: "ENTRY_CATEGORY".
        static let catg = "ENTRY_CATEGORY"
    }
    
    /// This inner struct contains strings used by `Vote` type.
    struct Vote {
        
        /// This CKRecord key matches "up: Bool" value in "Vote" database record: "VOTE_UP".
        static let appr = "VOTE_UP"
        
        /// This CKRecord key matches "constituent: CKReference" value in "Vote" database record: "VOTE_VOTER".
        static let votr = "VOTE_VOTER"
        
        /// This CKRecord key matches "candidate: CKReference" value in "Vote" database record: "VOTE_SUBJECT".
        static let subj = "VOTE_SUBJECT"
    }
    
    /// This inner struct contains strings used by `Flag` type.
    struct Flag {
        
        /// This CKRecord key matches "reason: FlagReason (a)" value in "Flag" database record: "FLAG_REASON".
        static let rea0 = "FLAG_REASON"
        
        /// This CKRecord key matches "reason: FlagReason (b)" value in "Flag" database record: "FLAG_REASON_AUXILIARY".
        static let rea1 = "FLAG_REASON_AUXILIARY"
    }
    
    /// This inner struct contains strings used by all `Suggestion` type (flag + edit + new).
    struct Suggestion {
        
        /// This CKRecord key matches "creator: CKReference" value in "Suggestion" database records: "SUGGESTED_CREATOR".
        static let crtr = "SUGGESTED_CREATOR"
        
        /// This CKRecord key matches "index: Int" value in "Suggestion" database records: "FLAG_EMAIL".
        static let mail = "SUGGESTED_EMAIL"
        
        /// This CKRecord key matches "index: Int" value in "Suggestion" database records: "SUGGESTED_CATEGORY".
        static let ncat = "SUGGESTED_CATEGORY"
        
        /// This CKRecord key matches "index: Int" value in `Suggestion` database records: "SUGGESTED_TEXT".
        static let ntxt = "SUGGESTED_TEXT"
        
        /// This CKRecord key matches "index: Int" value in `Suggestion` database records: "SUGGESTED_STATE".
        static let stat = "SUGGESTED_STATE"
    }
    
    // Universal Keys
        
    /// This CKRecord key matches various CKReference or [CKReference] values in various database records: "RECORD_OWNERS".
    static let refs = "RECORD_OWNERS"
}

// MARK: - URL Strings

/// This struct contains various URL addresses as strings.
struct URL_str {
    
    /// This static constant stores the URL address for the Escape Chaos home page: "https://escapechaos.com".
    static let homePage = "https://escapechaos.com"
    
    /// This static constant stores the URL address for Escape Chaos' SBAdvisor page: ""https://escapechaos.com/advisor".
    static let advisorPage = "https://escapechaos.com/advisor"
    
    /// This static constant stores the URL address for the Escape Chaos Advisor blog: "https://escapechaos.com/blog".
    static let blogPage = "https://escapechaos.com/blog"
}

// MARK: - Email Addresses

/// This struct contains various email addresses as strings.
struct EmailAddress {
    
    /// This static constant stores the email address for Escape Chaos' SBA team.
    static let sba = "sba@escapechaos.com"
}


