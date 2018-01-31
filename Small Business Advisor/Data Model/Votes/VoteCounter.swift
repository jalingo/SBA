//
//  VoteCounter.swift
//  Small Biz Advisor
//
//  Created by Hayley McCrory on 11/18/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

/// This protocol can be adopted by types that need to tabulate votes and rank tips based on their popularity.
protocol VoteCounter {
    
    /// This read-only property contains an up-to-date collection of all the votes currently in the database.
    var allVotes: [VoteAbstraction] { get }
    
    /**
        This method orders an array of tips based on their popularity, and possibility to limit results based on category. More votes equals an earlier position in the returned array (e.g. index of 0 is the most popular position).
     
        - Parameters:
            - for: Array of tips to be ordered by votes accrued.
            - by: If not nil, results will be limited to tips that match specified category.
     
        - Returns: An array of tips sorted by vote popularity (the more votes, the lower the index in the array).
     */
    func rank(for: [Tip], by: TipCategory?) -> [Tip]
}

extension VoteCounter {
    
    // MARK: - Functions
    
    /**
        This method sorts dictionary passed, filtering out entries that do not match the category passed, by vote popularity (higher rank = lower index).
     
        - Parameters:
            - dictionary: An argument containing a key for each Tip and a score value that corresponds to the Tip's net vote score.
            - category: The category results will be filtered against (only returns matching).
        - Returns: An array of Tips, sorted with greater score = lower index, containing only tips matching the specified category.
     */
    fileprivate func sort(_ dictionary: [Tip: Int], filteredBy category: TipCategory) -> [Tip] {
        let subSet = dictionary.filter { $0.key.category == category }
        return sortBy(rank: subSet)
    }
    
    /**
        This method sorts dictionary passed, by vote popularity (higher rank = lower index).
     
        - Parameter dictionary: An argument containing a key for each Tip and a score value that corresponds to the Tip's net vote score.
        - Returns: An array of Tips, sorted with greater score = lower index.
     */
    fileprivate func sortBy(rank dictionary: [Tip: Int]) -> [Tip] {
        return dictionary.keys.sorted {
            guard dictionary[$0] != nil else { return false }   // <-- Test direction pointing: true v false
            guard dictionary[$1] != nil else { return true }
            
            return dictionary[$0]! > dictionary[$1]!
        }
    }
    
    /**
        This method compares votes cast for each tip in tips passed, generating a score (+1 for, -1 against) for each one. The result returned is a dictionary with a key for each tip and corresponding score as value.
     
        - Parameter tips: An array of tips to be scored based on votes cast.
        - Returns: A dictionary containing a key for each Tip and a score value that corresponds to the Tip's net vote score.
     */
    fileprivate func tabulateResults(for tips: [Tip]) -> [Tip: Int] {
        var dictionary = [Tip: Int]()
        for tip in tips { dictionary[tip] = 0 }     // <-- Initializes dictionary with all tips as keys.
        let copy = dictionary
        
        for entry in copy {
            for vote in allVotes {
                let name = vote.candidate.recordID.recordName
                if let index = Int(name[5...]), entry.key.index == index {
                    vote.isFor ?
                        (dictionary[entry.key]! += 1) : (dictionary[entry.key]! -= 1)
                }
            }
        }
        
        return dictionary
    }
    
    // MARK: - Functions: VoteCounter
    
    func rank(for tips: [Tip], by category: TipCategory? = nil) -> [Tip] {
        let result = tabulateResults(for: tips)
        if let category = category {
            return sort(result, filteredBy: category)
        } else {
            return sortBy(rank: result)
        }
    }
}
