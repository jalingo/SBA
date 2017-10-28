//
//  Response.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/28/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

// Response pulls information from the data model and prepares it for delivery to the view controller.

protocol ResponseAggregator {
    
    func byRandom() -> NSAttributedString
    
    func byIndex(of: Int) -> NSAttributedString
}

struct Response: ResponseAggregator {
    
    func byRandom() -> NSAttributedString {
        let random = TipFactory.produceByRandom()
        
        let category = random.category.bold
        let text = random.text
        
        return NSAttributedString(string: "\(category)\n\n\(text)")
    }
    
    func byIndex(of index: Int) -> NSAttributedString {
        
        let category = TipCategoryFactory.produceByIndex(index: index).bold
        let text = TextFactory.produce(for: index)
        
        return NSAttributedString(string: "\(category)\n\n\(text)")
    }
}
