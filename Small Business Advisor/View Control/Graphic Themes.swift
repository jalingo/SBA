//
//  Graphic Themes.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/14/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import UIKit

/// This contains system defaults for NSAttributedString formatting.
struct Format {
    
    static let ecGreen = UIColor(red: 0.55, green: 0.78, blue: 0.25, alpha: 1.0)
    
    static var style: NSMutableParagraphStyle {
        let _style = NSMutableParagraphStyle()
        _style.alignment = NSTextAlignment.center
        
        return _style
    }
    
    static var shadow: NSShadow {
        let _shadow = NSShadow()
        
        _shadow.shadowBlurRadius = 2
        _shadow.shadowOffset = CGSize(width: 1, height: 1)
        _shadow.shadowColor = UIColor.darkGray
        
        return _shadow
    }
    
    /// This method provides the formatting for attributed strings representing entry text.
    static var bodyText: [NSAttributedStringKey: NSObject] {
        let formatting = [
            NSAttributedStringKey.font :            font(size: 18.0),
            NSAttributedStringKey.foregroundColor:  ecGreen,
            NSAttributedStringKey.paragraphStyle:   style
        ]
        
        return formatting
    }
    
    /// This method provides the formatting for attributed strings representing category titles.
    static var categoryTitle: [NSAttributedStringKey: NSObject] {
        let formatting = [
            NSAttributedStringKey.font :            font(size: 24.0),
            NSAttributedStringKey.foregroundColor:  ecGreen,
            NSAttributedStringKey.shadow:           shadow,
            NSAttributedStringKey.paragraphStyle:   style
        ]
        
        return formatting
    }
    
    static func font(size: CGFloat) -> UIFont { return UIFont.boldSystemFont(ofSize: size) }
}

// MARK: - Extension: ButtonEnabler

// Set color themes for this app.
extension ButtonEnabler {
    var activeColor: UIColor { return Format.ecGreen }
    var inactiveColor: UIColor { return .gray }
}
