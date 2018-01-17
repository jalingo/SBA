//
//  Type Aliases & Strings.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 11/4/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

// MARK: - Type Aliases

/// Used by the AnyPicker class to pass activity for the didSelect method.
typealias PickerBlock = ((Pickable) -> ())?

// MARK: - Key Strings

struct RecordType {

    static let entry = "ADVISOR_ENTRY"

    static let vote = "ADVISOR_VOTE"
        
    static let category = "ADVISOR_CATEGORY"
        
    static let voter = "ADVISOR_VOTER"
        
    static let mock = "MOCK_RECORD"
    
    static let flag = "SUGGESTED_FLAG"
    
    static let edit = "SUGGESTED_EDIT"
    
    static let newt = "SUGGESTED_TIP"
}
    
struct RecordKey {

    // Entry Keys

    static let indx = "ENTRY_INDEX"
    
    static let text = "ENTRY_TEXT"
        
    static let rank = "ENTRY_RANK"
    
    static let catg = "ENTRY_CATEGORY"
    
    // Vote Keys

    static let appr = "VOTE_UP"
    
    static let votr = "VOTE_VOTER"
    
    static let subj = "VOTE_SUBJECT"
    
    // Flag Keys
    
    static let rea0 = "FLAG_REASON"

    static let rea1 = "FLAG_REASON_AUXILIARY"
    
    static let crtr = "FLAG_CREATOR"
    
    static let mail = "FLAG_EMAIL"
    
    // NewTip / Edit Keys
    
    static let ncat = "SUGGESTED_CATEGORY"
    
    static let ntxt = "SUGGESTED_TEXT"
    
    // Universal Keys
        
    static let refs = "RECORD_OWNERS"
}

// MARK: - URL Strings

struct URL_str {
    
    static let homePage = "https://escapechaos.com"
    
    static let advisorPage = "https://escapechaos.com/advisor"
    
    static let blogPage = "https://escapechaos.com/blog"
}

// MARK: - Text Strings

struct Instructions {
    
    static let shake = "Shake for Advice!"
    
    static let swipe = "Swipe through the various tips..."
    
    static let help = """
To contact the app's creators with any questions or comments: dev@escapechaos.com

Or, check out our site escapechaos.com/advisor
"""
}
