//
//  PickerDecorator.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/23/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

// !! factor out into it's own file
protocol PickerDecorator: UIPickerViewDelegate, UIPickerViewDataSource {
    func decorate(_ picker: UIPickerView, for vc: UIViewController)
}

extension PickerDecorator {
    
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
