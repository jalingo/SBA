//
//  Pickable.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/25/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import MagicCloud

// !!
protocol Pickable: MCRecordable {
    var title: String { get }
}

// MARK: - Extensions

// MARK: - Extension: Tip

extension Tip: Pickable {
    var title: String { return self.text.string[0...30] }
}

// MARK: - Extension: TipCategory

extension TipCategory: Pickable {
    var title: String { return self.formatted.string }
}
