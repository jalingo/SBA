//
//  FieldsEditorPickerDelegation.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/26/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

// MARK: - Extensions

// MARK: - Extension: UIPickerViewDataSource

extension FieldsEditorViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.recordables.count + 1
    }
}

// MARK: - Extension: UIPickerViewDelegate

extension FieldsEditorViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TipCategory(rawValue: row)?.formatted.string
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return TipCategory(rawValue: row)?.formatted
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == categories.recordables.count + 1 {
            recoverNewCategoryTitle()
        } else {
            guard let cat = TipCategory(rawValue: row) else { return }
            if tipBeingEdited != nil {
                tipBeingEdited!.category = cat
            } else {
                selectedCategory = cat.formatted.string
            }
        }
        
        pickerView.removeFromSuperview()
    }
    
    /// This method asks USER to input new category title from an alert message.
    // !! TODO NOT TESTED
    fileprivate func recoverNewCategoryTitle() {
        let alert = UIAlertController(title: "New Category Suggestion", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = "Spaces are fine..."
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak alert] (_) in
            self.selectedCategory = alert?.textFields?[0].text
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
