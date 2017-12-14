//
//  TipFactory.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/31/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

import MagicCloud

protocol _TipFactoryAbstraction {
    
    var limitation: TipCategory? { get set }
    
    var lastRank: Int { get set }
    
    var count: Int { get }
    
    func rank(of: Int) -> Tip?
    
    func random() -> Tip?
}

extension _TipFactoryAbstraction {
    
    // MARK: - Functions
    
    func random() -> Tip? {
        let randomRank = Int(arc4random_uniform(UInt32(count)))
        return rank(of: randomRank)
    }
}

class _TipFactory: MCReceiver<Tip>, _TipFactoryAbstraction {
    
    // MARK: - Properties

    let votes = VotingBooth(db: .publicDB)
    
    // MARK: - Properties: TipFactory
    
    var lastRank = -1
    
    var count: Int { return self.recordables.count }
    
    var limitation: TipCategory?
    
    // MARK: - Functions

    // MARK: - Functions: TipFactory

    func rank(of place: Int) -> Tip? {
        guard place > 0 else { return rank(of: 1) }
        guard place < count + 1 else { return rank(of: count) }

        lastRank = place
        
        // sort based on votes here...
        return votes.rank(for: recordables, by: limitation)[place - 1]
    }
    
    // MARK: - InnerClasses
    
    class VotingBooth: MCReceiver<Vote>, VoteCounter {
        var allVotes: [VoteAbstraction] { return recordables }
    }
}

// MARK: Protocol

/**
    This protocol ensures that the factory produces entries by both random and specified index.
 
    Contains `max` property, making it factory's responsibility to count total entries listed.
 */
protocol EntryFactory {

    /// This read only property returns the total number of entries.
    static var max: Int { get }
    
    /**
        This method decorates and returns an Entry specified by index.
     
        - Parameter index: An integer reflecting the unique identifier for each entry.
        - Returns: A specified instance conforming to Entry.
     */
    static func produceByIndex(index: Int) -> Entry

    /**
        This method decorates and returns a random Entry.
     
        - Returns: A random instance conforming to Entry.
     */
    static func produceByRandom() -> Entry
}

// MARK: - Struct

/// This struct conforming to `EntryFactory` produces tips for `ResponseText` to provide to `AdvisorVC`.
struct TipFactory: EntryFactory {
    
    /// This constant property returns the total number of tips the factory can produce.
    /// After the database is built, this will have to become a computed property.
    static let max = 105

    /**
        This method decorates and returns a Tip specified by index.
     
        - Parameter index: An integer reflecting the unique identifier for each Tip.
        - Returns: The Tip specified.
     */
    static func produceByIndex(index integer: Int) -> Entry {
        return Tip(index: integer, category: TipCategoryFactory.produceByIndex(index: integer), text: TextFactory.produce(for: integer))
    }
    
    /**
        This method decorates and returns a random Entry.
     
        - Returns: A random Tip.
     */
    static func produceByRandom() -> Entry {
        let random = Int(arc4random_uniform(UInt32(self.max)))
        return produceByIndex(index: random)
    }
}
