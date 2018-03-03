//
//  Graphic Themes.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/14/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import UIKit

// MARK: Struct

/// This struct contains system defaults for NSAttributedString formatting.
struct Format {
    
    // MARK: - Properties

    /// This static constant stores the rgb values for theme color "Escape Chaos Green"
    static let ecGreen = UIColor(red: 0.55, green: 0.78, blue: 0.25, alpha: 1.0)

    // !!
    static let ecRed = UIColor(displayP3Red: 1.0, green: 0.15, blue: 0.0, alpha: 1.0)
    
    /// This static computed property returns a centered mutable paragraph style for attributed strings.
    static var style: NSMutableParagraphStyle {
        let _style = NSMutableParagraphStyle()
        _style.alignment = NSTextAlignment.center
        
        return _style
    }
    
    /// This static computed property returns a standartdized shadow adjustment for attributed strings.
    static var shadow: NSShadow {
        let _shadow = NSShadow()
        
        _shadow.shadowBlurRadius = 2
        _shadow.shadowOffset = CGSize(width: 1, height: 1)
        _shadow.shadowColor = UIColor.darkGray
        
        return _shadow
    }
    
    /// This static computed property returns the formatting representing body text for attributed strings.
    static var bodyText: [NSAttributedStringKey: NSObject] {
        return [
            NSAttributedStringKey.font :            font(size: 18.0),
            NSAttributedStringKey.foregroundColor:  ecGreen,
            NSAttributedStringKey.paragraphStyle:   style
        ]
    }
    
    /// This static computed property returns the formatting representing category titles for attributed strings.
    static var categoryTitle: [NSAttributedStringKey: NSObject] {
        return [
            NSAttributedStringKey.font :            font(size: 24.0),
            NSAttributedStringKey.foregroundColor:  ecGreen,
            NSAttributedStringKey.shadow:           shadow,
            NSAttributedStringKey.paragraphStyle:   style
        ]
    }
    
    // MARK: - Functions
    
    /**
        This method returns a bold system font at the passed size.
        - Parameter size: Numerical size of text font.
     */
    static func font(size: CGFloat) -> UIFont { return UIFont.boldSystemFont(ofSize: size) }
}

// MARK: - Extension: ButtonEnabler

// Set color themes for this app's buttons.
extension ButtonEnabler {

    /// This read-only property returns the color updateButton will display to indicate enabled.
    var activeColor: UIColor { return Format.ecGreen }
    
    /// This read-only property returns the color updateButton will display to indicate disabled.
    var inactiveColor: UIColor { return .gray }
}
