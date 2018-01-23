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

// !! factor out into it's own file
protocol CategoryPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func decorate(_ picker: UIPickerView, for vc: UIViewController)
}

extension CategoryPicker {
    
    func centeredBox(inside view: UIView) -> CGRect {
        let width = view.frame.width * 0.9
        let height = view.frame.height * 0.6
        
        let x = width / 18
        let y = height * 0.3
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // !!
    func decorate(_ picker: UIPickerView, for vc: UIViewController) {
        picker.showsSelectionIndicator = true
        picker.selectedRow(inComponent: 0)
        
        picker.frame = centeredBox(inside: vc.view)
        picker.layer.borderWidth = 2.0
        picker.backgroundColor = .white
        
        picker.delegate = self
        picker.dataSource = self
    }
}

// MARK: - Extension: String

extension String {
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }
    
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start...end])
    }
}

// MARK: - Extension: ButtonEnabler

// Set color themes for this app.
extension ButtonEnabler {
    var activeColor: UIColor { return Format.ecGreen }
    var inactiveColor: UIColor { return UIColor(displayP3Red: 0.67, green: 0.67, blue: 0.67, alpha: 1.0) }
}
