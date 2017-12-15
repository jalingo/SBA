////
////  Response.swift
////  Small Business Advisor
////
////  Created by James Lingo on 10/28/17.
////  Copyright © 2017 Escape Chaos. All rights reserved.
////
//
//import UIKit
//
//// MARK: Protocol
//
///// This protocol pulls information from data model and prepares it for delivery to the view controller.
//protocol ResponseAggregator {
//    
//    /// This property saves the index of the last Entry recovered, to allow harvesting more info than body text.
//    var lastIndex: Int { get }
//    
//    /// This method returns a formatted string from a random entry.
//    mutating func byRandom() -> NSAttributedString
//    
//    /// This method returns a formatted string from an entry specified by index.
//    mutating func byIndex(of: Int) -> NSAttributedString
//}
//
//// MARK: - Struct
//
///**
//    This struct conforms to `ResponseAggregator` and can be used to generate multiple strings of text from the
//    data model, either at random or by specified index.
// */
//struct ResponseText: ResponseAggregator {
//    
//    // MARK: - Properties
//    
//    /// This fileprivate property stores the index of the last entry harvested.
//    fileprivate var _lastIndex = 0
//    
//    /**
//        This computed property is read only and returns the index associated with the last string generated from
//        either `byIndex(of:)` or `byRandom` methods in this struct.
//     */
//    var lastIndex: Int { return _lastIndex }
//    
//    // MARK: - Functions
//    
//    /**
//        This method acquires an entry from the data model at random, and then formats it's category title and
//        body text for presentation on the view controller.
//     
//         - Warning: `_lastIndex` must be set when this method runs or `lastIndex` cannot compute properly.
//     
//         - Returns: Formatted string associated with a random entry, ready to be displayed to the USER.
//     */
//    mutating func byRandom() -> NSAttributedString {
//        let random = _TipFactory(db: .publicDB).random
//        
//        _lastIndex = random.index
//        
//        let response = random.category.formatted
//        response.append(NSAttributedString(string: "\n\n"))
//        response.append(random.text)
//        
//        return response
//    }
//    
//    /**
//        This method acquires an entry from the data model based on specified index, and then formats it's category
//        title and body text for presentation on the view controller.
//     
//         - Warning: `_lastIndex` must be set when this method runs or `lastIndex` cannot compute properly.
//     
//         - Parameters:
//             - of: This parameter intakes the index of the entry whose data has been requested.
//     
//         - Returns: Formatted string associated with a specified entry, ready to be displayed to the USER.
//     */
//    mutating func byIndex(of index: Int) -> NSAttributedString {
//        
//        _lastIndex = index
//        
//        let response = TipCategoryFactory.produceByIndex(index: index).formatted
//        response.append(NSAttributedString(string: "\n\n"))
//        response.append(TextFactory.produce(for: index))
//        
//        return response
//    }
//}

