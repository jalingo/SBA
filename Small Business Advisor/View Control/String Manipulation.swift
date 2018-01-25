//
//  String Manipulation.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/24/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import Foundation

// MARK: - Extension: String

// This extension contains subscript accessors (str[x]) for various string segmentations.
extension String {
    
    // creates subscript accessor for char at specified index.
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    // creates subscript accessor for str at specified index.
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    // creates subscript accessor for substring (as str) in specified open range.
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }
    
    // creates subscript accessor for substring (as str) in specified closed range.
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start...end])
    }
}

// This extension contains methods that access string aspects of the attributed string.
extension NSAttributedString {
    
    // this method returns range of string in attributed string, or nil if not present.
    func rangeOf(string: String) -> Range<String.Index>? {
        return self.string.range(of: string)
    }
}
