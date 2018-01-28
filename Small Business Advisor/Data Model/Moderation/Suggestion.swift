//
//  Suggestion.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/22/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import MagicCloud
import CloudKit

/// !!
protocol ModerationSuggester {
   
    /// !!
    associatedtype type: SuggestedModeration
    
    /// !!
    func isUnderLimit(for recordable: [MCRecordable]) -> Bool
}

/// !!
protocol SuggestedModeration {

    /// !!
    var editorEmail: String? { get set }

    /// !!
    var tip: CKReference     { get set }
  
    /// !!
    var creator: CKRecordID? { get set }

    /// !!
    static var limit: Int?   { get }
}

extension ModerationSuggester {
    
    func isUnderLimit(for recordables: [MCRecordable]) -> Bool {
        guard let user = MCUserRecord().singleton else { return false }
        guard let limit = type.limit else { return true }
        
        var matches = 0
        for record in recordables {
            if let suggestion = record as? SuggestedModeration, suggestion.creator == user { matches += 1 }
        }
        
        return matches < limit
    }
}

/// !!
struct AnyModerator<T: SuggestedModeration>: ModerationSuggester {
    typealias type = T
}
