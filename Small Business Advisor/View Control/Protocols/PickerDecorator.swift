//
//  PickerDecorator.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/23/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

// MARK: Protocol

/// This protocol ensures conforming types can decorate a picker and provide it's delegate and dataSource.
protocol PickerDecorator: UIPickerViewDelegate, UIPickerViewDataSource {
    
    /**
        This method decorates passed picker for passed view controller including frame, color, borders and delegation.
     
        - Parameters:
            - picker: The pickerView being decorated for presentation.
            - vc: The viewController presenting pickerView (needed for framing; should be fullscreen).
     */
    func decorate(_ picker: UIPickerView, for vc: UIViewController)
}

// MARK: - Extensions

extension PickerDecorator {
    
    /**
        This method returns CGRect for framing pickerView in the center of passed view.
        - Parameter view: the iOS fullscreen view that pickerView should be centered within.
     */
    func centeredBox(inside view: UIView) -> CGRect {
        let width = view.frame.width * 0.9
        let height = view.frame.height * 0.6
        
        let x = width / 18
        let y = height * 0.3
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    /**
        This method decorates passed picker for passed view controller including frame, color, borders and delegation.
     
        - Parameters:
            - picker: The pickerView being decorated for presentation.
            - vc: The viewController presenting pickerView (needed for framing; should be fullscreen).
     */
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
