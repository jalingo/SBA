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

/** !!
 This protocol ensures that the factory produces entries by both random and specified index.
 
 Contains `max` property, making it factory's responsibility to count total entries listed.
 */

protocol _TipFactoryAbstraction {
    
    var limitation: TipCategory? { get set }
    
    var lastRank: Int { get set }
    
    /// This read only property returns the total number of entries.
    var count: Int { get }
    
    /** !!
     This method decorates and returns an Entry specified by index.
     
     - Parameter index: An integer reflecting the unique identifier for each entry.
     - Returns: A specified instance conforming to Entry.
     */
    func rank(of: Int) -> Tip
    
    /** !!
     This method decorates and returns a random Entry.
     
     - Returns: A random instance conforming to Entry.
     */
    func random() -> Tip
}

extension _TipFactoryAbstraction {
    
    // MARK: - Functions
    
    func random() -> Tip {
        guard count != 0 else { return Tip() }
        let randomRank = Int(arc4random_uniform(UInt32(count)))

        return rank(of: randomRank)
    }
}

// MARK: - Class

class TipFactory: MCReceiver<Tip>, _TipFactoryAbstraction {
    
    // MARK: - Properties

    let votes = VotingBooth(db: .publicDB)
    
    // MARK: - Properties: TipFactory
    
    var lastRank = -1
    
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
    
    var limitation: TipCategory?
    
    // MARK: - Functions

    // MARK: - Functions: TipFactory

    func rank(of place: Int) -> Tip {
        guard recordables.count != 0 else { return Tip() }
        guard place > 0 else { return rank(of: 1) }
        guard place < count + 1 else { return rank(of: count) }

        lastRank = place
        
        // sort based on votes here...
        return votes.rank(for: recordables, by: limitation)[place - 1]
    }
 
    init() {
print("     TipFactory.init")
        super.init(db: .publicDB)
    }
    
    // MARK: - InnerClasses
    
    class VotingBooth: MCReceiver<Vote>, VoteCounter {
        var allVotes: [VoteAbstraction] { return recordables }
        
        override init(db: MCDatabase) {
print("     TipFactory.VotingBooth.init")
            super.init(db: db)
        }
    }
}

