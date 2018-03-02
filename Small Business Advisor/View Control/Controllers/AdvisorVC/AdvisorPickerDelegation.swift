//
//  AdvisorPickerDelegation.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/26/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

// MARK: - Extensions

extension AdvisorViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return TipCategory(rawValue: row)?.formatted
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TipCategory(rawValue: row)?.formatted.string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let category = TipCategory(rawValue: row) {
            selectCategoryButton.setAttributedTitle(category.formatted, for: .normal)
            self.tips?.limitation = category
            self.increasePage()
        }
        
        pickerView.removeFromSuperview()
    }
}

extension AdvisorViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return TipCategory.max }
}
