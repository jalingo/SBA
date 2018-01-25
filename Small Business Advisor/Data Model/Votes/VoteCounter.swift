//
//  VoteCounter.swift
//  Small Biz Advisor
//
//  Created by Hayley McCrory on 11/18/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

protocol VoteCounter {
    
    // !!
    var allVotes: [VoteAbstraction] { get }
    
    // !!   <-- Is this needed in the protocol?
    func tabulateResults(for: [Tip]) -> [Tip: Int]
    
    // !!
    func rank(for: [Tip], by: TipCategory?) -> [Tip]
}

extension VoteCounter {
    
    // MARK: - Functions
    
    fileprivate func sort(_ dictionary: [Tip: Int], filteredBy category: TipCategory) -> [Tip] {
        let subSet = dictionary.filter { $0.key.category == category }
        return sortBy(rank: subSet)
    }
    
    fileprivate func sortBy(rank dictionary: [Tip: Int]) -> [Tip] {
        return dictionary.keys.sorted {
            guard dictionary[$0] != nil else { return false }   // <-- Test direction pointing: true v false
            guard dictionary[$1] != nil else { return true }
            
            return dictionary[$0]! > dictionary[$1]!
        }
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
    
    func tabulateResults(for tips: [Tip]) -> [Tip: Int] {
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
}
