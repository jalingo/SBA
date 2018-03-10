//
//  NextTipIndex.swift
//  SBAdmin
//
//  Created by James Lingo on 3/10/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import Foundation

protocol TipIndexGenerator {
    var tips: [Tip]? { get set }
}

extension TipIndexGenerator {
    func generateNextTipIndex() -> Int? {
        guard let tips = tips else { return nil }
        
        var highestIndex = 0
        for tip in tips {
            if tip.index > highestIndex { highestIndex = tip.index }
        }
        
        return highestIndex + 1
    }
}
