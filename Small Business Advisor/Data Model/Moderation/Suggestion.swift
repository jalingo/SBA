//
//  Suggestion.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/22/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import MagicCloud
import CloudKit

// MARK: Protocols

/// This protocol is conformed by view controllers that will save moderation records to database.
protocol ModerationSuggester {
   
    /// This type association references the suggested moderation that suggester will suggest.
    associatedtype type: SuggestedModeration
    
    /**
        This method reviews the suggestions passed, and returns true when the number of suggestions created by USER in set are less than the suggestion's limit.

        - Parameter suggestions: An array of associatedtype whose entries may have been created by USER.
        - Returns: true when the number of suggestions created by USER in set are less than the suggestion's limit.
     */
    func isUnderLimit(for suggestions: [type]) -> Bool
}

/// This abstract parent class for USER list moderation (e.g. flag, edit, new, etc...).
protocol SuggestedModeration {

    /// This optionl property stores an email address, if supplied by the USER, to contact them about the results of their suggested moderation.
    var editorEmail: String? { get set }

    /// This property stores a database reference to the Tip suggested moderation concerns.
    var tip: CKReference     { get set }
  
    /// This optional property stores database identifier for the USER suggesting moderation.
    var creator: CKRecordID? { get set }

    ///  This property stores a moderation state used to track it's approval progress.
    var state: ModerationState { get set }
    
    /// This static, read-only & optional property returns the maximum amount of active moderation records in the database (by type) the USER is limited to.
    static var limit: Int?   { get }
}

// MARK: - Enums

/// This enumerates the moderation states used to track `SuggestedModeration` approval progress.
enum ModerationState: Int {
    
    /// This state represents a `SuggestedModeration` submmitted by the USER, but not yet recognized by the system.
    case submitted = 0
    
    /// This state represents a `SuggestedModeration` recognized by the system, but not yet resolved.
    case opened = 1
    
    /// This state represents a `SuggestedModeration` resolved by the system as approved.
    case closedApproved = 2
    
    /// This state represents a `SuggestedModeration` resolved by the system as rejected.
    case closedRejected = 3
}

// MARK: - Extensions

extension ModerationSuggester {
    
    func isUnderLimit(for suggestions: [type]) -> Bool {
        guard let user = MCUserRecord().singleton else { return false }
        guard let limit = type.limit else { return true }
        
        var matches = 0
        for suggestion in suggestions where suggestion.creator == user && suggestion.state == .submitted { matches += 1 }

        return matches < limit
    }
}

/// This wrapper struct allows for rapidly checking limits for passed arguments to extended isUnderLimit:suggestions:
struct AnyModerator<T: SuggestedModeration>: ModerationSuggester {
    typealias type = T
}
