//
//  ButtonEnabler.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/23/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

// !! funcs need to run on main thread
protocol ButtonEnabler {
    
    var updateButton: UIButton { get }
    
    var activeColor: UIColor { get }
    
    var inactiveColor: UIColor { get }
    
    func enableChanges()
    
    func disableChanges()
}

extension ButtonEnabler {
    
    var activeColor: UIColor { return UIColor(displayP3Red: 0.55, green: 0.78, blue: 0.25, alpha: 1.0) }
    
    var inactiveColor: UIColor { return UIColor(displayP3Red: 0.67, green: 0.67, blue: 0.67, alpha: 1.0) }
    
    func enableChanges() {
        updateButton.isEnabled = true
        updateButton.backgroundColor = activeColor
    }
    
    func disableChanges() {
        updateButton.isEnabled = false
        updateButton.backgroundColor = inactiveColor
    }
}
