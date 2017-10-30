//
//  Response.swift
//  Small Business Advisor
//
//  Created by James Lingo on 10/28/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import UIKit

// Response pulls information from the data model and prepares it for delivery to the view controller.

protocol ResponseAggregator {
    
    var lastIndex: Int { get }
    
    mutating func byRandom() -> NSAttributedString
    
    mutating func byIndex(of: Int) -> NSAttributedString
}

struct ResponseText: ResponseAggregator {
    
    fileprivate var _lastIndex = 0
    
    var lastIndex: Int { return _lastIndex }
    
    mutating func byRandom() -> NSAttributedString {
        let random = TipFactory.produceByRandom()
        
        _lastIndex = random.index
        let category = random.category.formatted
        
        let response = NSMutableAttributedString(attributedString: category)
        response.append(NSAttributedString(string: "\n\n"))
        response.append(random.text)
        
        return response
    }
    
    mutating func byIndex(of index: Int) -> NSAttributedString {
        
        _lastIndex = index
        let category = TipCategoryFactory.produceByIndex(index: index).formatted
        let text = NSAttributedString(string: "\n\n\(TextFactory.produce(for: index))")
        category.append(text)
        
        return category
    }
    
    init() {
        
    }
}
