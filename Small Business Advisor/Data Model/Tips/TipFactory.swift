//
//  TipFactory.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/31/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import MagicCloud

// MARK: Protocol

/**
    This protocol ensures that the factory produces entries by both random and specified index.
 
    Contains `max` property, making it factory's responsibility to count total entries listed.
 */
protocol TipFactoryAbstraction {
    
    // MARK: - Properties

    /// This optional property should trigger a category limitation when not nil. When not nil, all methods and computed properties return results limited to the subset of tips that matches the category specified.
    var limitation: TipCategory? { get set }
    
    /// This property saves the rank of the last tip factory produced and returned.
    var lastRank: Int { get set }
    
    /// This read only property returns the total number of entries.
    var count: Int { get }

    // MARK: - Functions
    
    /**
        This method decorates and returns an Entry specified by rank.
     
        - Parameter rank: An integer reflecting the place requested.
        - Returns: A specified instance conforming to Entry.
     */
    func rank(of: Int) -> Tip
    
    /**
        This method decorates and returns a random Entry.
     
        - Returns: A random instance conforming to Entry.
     */
    func random() -> Tip
}

extension TipFactoryAbstraction {
    
    // MARK: - Functions
    
    /**
        This method decorates and returns a random Entry.
     
        - Returns: A random instance conforming to Entry.
     */
    func random() -> Tip {
        guard count != 0 else { return Tip() }
        let randomRank = Int(arc4random_uniform(UInt32(count)))

        return rank(of: randomRank)
    }
}

// MARK: - Class

/// This class produces entries (tips) recovered from the database, both by random and by rank. Also, maintains an up-to-date count of entries in database. Sub-class of MCReceiver<Tip>.
class TipFactory: MCReceiver<Tip>, TipFactoryAbstraction {
    
    // MARK: - Properties

    /// This constant property connects to the cloud and manages all vote records, conforming to MCRecievesRecordable<Vote>. Access votes as array in votes.recordables. Also, contains vote counting / tip ranking methods.
    let votes = VotingBooth(db: .publicDB)
    
    // MARK: - Properties: TipFactory
    
    /// This property saves the rank of the last tip factory produced and returned.
    var lastRank = -1
    
    /// This optional property triggers a category limitation when not nil. When not nil, all methods and computed properties return results limited to the subset of tips that matches the category specified.
    var limitation: TipCategory?
    
    /// This read-only, computed property returns the total number of tips in database (will limit count by category if limitation active).
    var count: Int {
        if let cat = limitation {
            var count = 0
            for tip in recordables {
                if tip.category == cat { count += 1 }
            }
            
            return count
        } else {
            return self.recordables.count
        }
    }
    
    // MARK: - Functions

    // MARK: - Functions: TipFactory

    /**
        This method decorates and returns an Entry currently at the specified rank.
     
        - Parameter rank: An integer reflecting the place requested.
        - Returns: A specified instance conforming to Entry.
     */
    func rank(of place: Int) -> Tip {
        guard recordables.count != 0 else { return Tip() }
        guard place > 0 else { return rank(of: 1) }
        guard place < count + 1 else { return rank(of: count) }

        lastRank = place
        
        // sort based on votes here...
        return votes.rank(for: recordables, by: limitation)[place - 1]
    }
 
    /// This constructor allows initialization with no parameter (defaults to .publicDB).
    init() { super.init(db: .publicDB) }
    
    // MARK: - InnerClasses
    
    /// This inner class connects to the cloud and manages all vote records, conforming to MCReciever<Vote>. Access votes as array in votes.recordables. Also, contains vote counting / tip ranking methods.
    class VotingBooth: MCReceiver<Vote>, VoteCounter {
        var allVotes: [VoteAbstraction] { return recordables }
    }
}

