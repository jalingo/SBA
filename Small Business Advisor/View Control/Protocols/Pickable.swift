//
//  Pickable.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/25/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import MagicCloud

/// This protocol supports conforming instances being listed in a UIPickerView.
protocol Pickable: MCRecordable {
    
    /// This read-only property returns a title string for display in UIPickerView cell.
    var title: String { get }
}

// MARK: - Extensions

// MARK: - Extension: Tip

extension Tip: Pickable {
    
    /// This read-only property returns a title string for display in UIPickerView cell.
    var title: String { return self.text.string[0...30] }
}

// MARK: - Extension: TipCategory

extension TipCategory: Pickable {
    
    /// This read-only property returns a title string for display in UIPickerView cell.
    var title: String { return self.formatted.string }
}
