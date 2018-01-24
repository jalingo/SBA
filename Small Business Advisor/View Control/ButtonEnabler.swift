//
//  ButtonEnabler.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/23/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

protocol ButtonEnabler {
    
    var updateButton: UIButton { get }
    
    var activeColor: UIColor { get }
    
    var inactiveColor: UIColor { get }
    
    func enableChanges(fgChange: Bool, bgChange: Bool)
    
    func disableChanges(fgChange: Bool, bgChange: Bool)
}

// !! funcs need to run on main thread
extension ButtonEnabler {
    
    func enableChangesWhileIgnoringFgColor() { enableChanges(fgChange: false, bgChange: true) }
    
    func disableChangesWhileIgnoringFgColor() { disableChanges(fgChange: false, bgChange: true) }
    
    func enableChangesWhileIgnoringBgColor() { enableChanges(fgChange: true, bgChange: false) }
    
    func disableChangesWhileIgnoringBgColor() { disableChanges(fgChange: true, bgChange: false) }
    
    func enableChanges(fgChange: Bool, bgChange: Bool) {
        updateButton.isEnabled = true
        if fgChange { updateButton.setTitleColor(activeColor, for: .normal) }
        if bgChange { updateButton.backgroundColor = activeColor }
    }
    
    func disableChanges(fgChange: Bool, bgChange: Bool) {
        updateButton.isEnabled = false
        if fgChange { updateButton.setTitleColor(inactiveColor, for: .normal) }
        if bgChange { updateButton.backgroundColor = inactiveColor }
    }
}
