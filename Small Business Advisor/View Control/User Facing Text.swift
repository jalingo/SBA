//
//  UserFacingText.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/26/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import Foundation

// MARK: - User Facing strings

/// This struct contains various USER facing instructions and explanations as strings.
struct UserFacingText {
    
    // MARK: - Instructions
    
    /// This static constant stores instructions for the shake gesture.
    static let shakeInstructions = "Shake for Advice!"
    
    /// This static constant stores instructions for the swipe gesture.
    static let swipeInstructions = "Swipe through the various tips..."
    
    /// This static constant stores instructions for the help button.
    static let helpInstructions = """
        To contact the app's creators with any questions or comments: dev@escapechaos.com
"""
    
    /// This static constant stores instructions for the resolving network issues.
    static let networkIssueInstructions = """
        We did not load advice, try again shortly.
        
        If they do not finish downloading momentarily, please ensure you are connected to the internet and logged into an iCloud account in settings.
        
        This app requires an internet connection and valid iCloud account to connect to it's database of small business advice.
        """
    
    // MARK: - Explanations
    
    /// This static constant stores an explanation for the suggestion limit.
    static let suggestionLimitExplanation = """
        Each user is limited to five active suggestions for edits and new tips. Once your existing suggestions have been reviewed, you will be able to make more suggestions.
        
        Thank you so much for being so helpful! Suggestions like yours improves the quality of our advice.
        """
    
    /// This static constant stores an explanation for the flag limit.
    static let flagLimitExplanation = "Each user can only have one active flag at a time."
    
    /// This static constant stores an explanation for moderator approval.
    static let moderatorApprovalExplanation = """
        Tap to edit.

        All changes and new tips must be approved by our moderators before they join the list. Tap 'Save' on the keyboard to submit your update.
        """
}
