//
//  Vote.swift
//  Small Biz Advisor
//
//  Created by Hayley McCrory on 11/18/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import CloudKit
import MagicCloud

protocol VoteAbstraction: Recordable {
    
    /// This property stores the direction vote was cast: for (true) or against (false).
    var isFor: Bool { get set }
    
    /// This property stores the tip that vote was cast for.
    var candidate: CKReference { get set }
    
    /// This property stores the voter that cast the ballot.
    var constituent: CKReference { get set }
}

