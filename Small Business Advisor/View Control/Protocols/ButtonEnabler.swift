//
//  ButtonEnabler.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/23/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

// MARK: Protocol

/// This protocol supports view controllers with UIButtons that need to change bg &/or fg colors when enabled / disabled.
protocol ButtonEnabler {
    
    // MARK: - Properties

    /// This read-only property returns the button that will change bg &/or fg colors when enabled / disabled.
    var updateButton: UIButton { get }
    
    /// This read-only property returns the color updateButton will display to indicate enabled.
    var activeColor: UIColor { get }
    
    /// This read-only property returns the color updateButton will display to indicate disabled.
    var inactiveColor: UIColor { get }
    
    // MARK: - Functions
    
    /**
        This method should enable updateButton and adjust colors as specified in parameters.
        - Parameters:
            - fgChange: A boolean parameter that specifies whether updateButton's title text color should change (will change when true).
            - bgChange: A boolean parameter that specifies whether updateButton's backgfound color should change (will change when true).
     */
    func enableChanges(fgChange: Bool, bgChange: Bool)
    
    /**
        This method should disable updateButton and adjust colors as specified in parameters.
        - Parameters:
            - fgChange: A boolean parameter that specifies whether updateButton's title text color should change (will change when true).
            - bgChange: A boolean parameter that specifies whether updateButton's backgfound color should change (will change when true).
     */
    func disableChanges(fgChange: Bool, bgChange: Bool)
}

// MARK: - Extensions

extension ButtonEnabler {
    
    // MARK: - Functions
    
    /// This method will enable changes while ignoring updateButton's title text color.
    func enableChangesWhileIgnoringFgColor() { enableChanges(fgChange: false, bgChange: true) }
    
    /// This method will disable changes while ignoring updateButton's title text color.
    func disableChangesWhileIgnoringFgColor() { disableChanges(fgChange: false, bgChange: true) }
    
    /// This method will enable changes while ignoring updateButton's background color.
    func enableChangesWhileIgnoringBgColor() { enableChanges(fgChange: true, bgChange: false) }
    
    /// This method will disable changes while ignoring updateButton's background color.
    func disableChangesWhileIgnoringBgColor() { disableChanges(fgChange: true, bgChange: false) }
    
    /**
        This method will enable updateButton and adjust colors as specified in parameters (recommend alternating parameters).
        - Parameters:
            - fgChange: A boolean parameter that specifies whether updateButton's title text color should change (will change when true).
            - bgChange: A boolean parameter that specifies whether updateButton's backgfound color should change (will change when true).
     */
    func enableChanges(fgChange: Bool, bgChange: Bool) {
        DispatchQueue.main.async {
            self.updateButton.isEnabled = true
            
            if fgChange { self.updateButton.setTitleColor(self.activeColor, for: .normal) }
            if bgChange { self.updateButton.backgroundColor = self.activeColor }
        }
    }
    
    /**
        This method will disable updateButton and adjust colors as specified in parameters (recommend alternating parameters).
        - Parameters:
            - fgChange: A boolean parameter that specifies whether updateButton's title text color should change (will change when true).
            - bgChange: A boolean parameter that specifies whether updateButton's backgfound color should change (will change when true).
     */
    func disableChanges(fgChange: Bool, bgChange: Bool) {
        DispatchQueue.main.async {
            self.updateButton.isEnabled = false

            if fgChange { self.updateButton.setTitleColor(self.inactiveColor, for: .normal) }
            if bgChange { self.updateButton.backgroundColor = self.inactiveColor }
        }
    }
}
