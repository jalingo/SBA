//
//  Type Aliases & Strings.swift
//  Small Biz Advisor
//
//  Created by Hayley McCrory on 11/4/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - Closures

typealias OptionalClosure = (()->())?

// MARK: - Cloud Closures

typealias QueryBlock = (CKQueryCursor?, Error?) -> Void

typealias FetchBlock = (CKRecord) -> Void

typealias ModifyBlock = ([CKRecord]?, [CKRecordID]?, Error?) -> Void

typealias NotifyBlock = (Notification) -> Void

// MARK: - Key Strings

struct Record {

    struct Type {

        static let entry = "ADVISOR_ENTRY"

        static let vote = "ADVISOR_VOTE"
        
        static let category = "ADVISOR_CATEGORY"
        
        static let voter = "ADVISOR_VOTER"
        
        static let mock = "MOCK_RECORD"
        
        static let test = "TEST_RECORD"
    }
    
    struct Key {

        // Entry Keys

        static let text = "ENTRY_TEXT"
        
        static let rank = "ENTRY_RANK"

        // Vote Keys

        static let appr = "VOTE_UP?"
        
        // Universal Keys
        
        static let refs = "RECORD_OWNERS"
    }
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
