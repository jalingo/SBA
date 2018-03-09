//
//  isFirstTryEver.swift
//  Voyager
//
//  Created by James Lingo on 9/3/17.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import Foundation

let FirstTryKey = "Has Run At Least Once"

protocol FirstTryDetector {}

extension FirstTryDetector {
    var isFirsRunEver: Bool {
        let defaults = UserDefaults()
        
        let hasRun = defaults.bool(forKey: FirstTryKey)
        
        if !hasRun { defaults.set(true, forKey: FirstTryKey) }
        
        return !hasRun
    }
}
