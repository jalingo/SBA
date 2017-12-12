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
    
    fileprivate func sort(_ dictionary: [Tip: Int], by category: TipCategory) -> [Tip] {
        return dictionary.keys.filter({ $0.category == category }).sorted { $0.score > $1.score }
    }
    
    fileprivate func sortBy(rank dictionary: [Tip: Int]) -> [Tip] {
        return dictionary.keys.sorted() { $0.score > $1.score }
    }
    
    // MARK: - Functions: VoteCounter
    
    func rank(for tips: [Tip], by category: TipCategory? = nil) -> [Tip] {
        let result = tabulateResults(for: tips)
        if let category = category {
            return sort(result, by: category)
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
                if let index = Int(vote.candidate.recordID.recordName), entry.key.index == index {
                    vote.isFor ?
                        (dictionary[entry.key] = entry.value + 1) : (dictionary[entry.key] = entry.value - 1)
                }
            }
        }
        
        return dictionary
    }
}
