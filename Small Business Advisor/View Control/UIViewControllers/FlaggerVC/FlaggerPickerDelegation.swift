//
//  FlaggerPickerDelegation.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/22/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import CloudKit

// MARK: Extensions

// MARK: - Extension: UIPickerViewDelegate

extension FlaggerViewController: UIPickerViewDelegate {
    
    // MARK: - Functions
    
    fileprivate func flagSelected(for row: Int) {
        DispatchQueue(label: "async off main").async {  // <-- !! Try async from main, then we can get rid of all the returns to main...
            switch row - 1 {
            case 0: self.setReason(to: .offTopic)
            case 1: self.setReason(to: .inaccurate)
            case 2: self.wrongTipSelected()
            case 3: self.wrongCategorySelected()
            case 4: self.setReason(to: .spam)
            case 5: self.setReason(to: .abusive)
            default: break
            }
        }
    }
    
    func setReason(to reason: FlagReason) {
        self.reason = reason
        DispatchQueue.main.async { self.updateViews() }
    }
    
    func wrongCategorySelected() {
        DispatchQueue.main.async {
            self.flaggerLabel.text = "Which Category should this tip be..."
            self.sampleModel = TipCategory.hr   // <-- Any category should trigger the correct delegate responses
            self.updateViews()
        }
    }
    
    func wrongTipSelected() {
        DispatchQueue.main.async {
            self.flaggerLabel.text = "Which Tip is this a duplicate of..."
            self.sampleModel = self.tip         // <-- Any tip should trigger the correct delegate responses
            self.updateViews()
        }
    }
    
    func categorySelected(for row: Int) {
        if let cat = TipCategory(rawValue: row) {
            let ref = CKReference(recordID: cat.recordID, action: .deleteSelf)
            setReason(to: .wrongCategory(ref))
        }
    }
    
    func tipSelected(for row: Int) {
        let tip = tips.rank(of: row)
        let ref = CKReference(recordID: tip.recordID, action: .deleteSelf)
        setReason(to: .duplicate(ref))
    }
    
    func flagTitle(for row: Int) -> String {
        switch row - 1 {
        case 0: return "Off Topic / Irrelevant"
        case 1: return "Inaccurate / Disputed"
        case 2: return "Duplicate of..."
        case 3: return "Wrong Category..."
        case 4: return "Spam / Advertisement"
        case 5: return "Abusive / Obscene Content"
        default: return "Select reason..."    // <-- For row == 0
        }
    }
    
    // MARK: - Functions: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let model = self.sampleModel {
            switch model.self {
            case is TipCategory:    categorySelected(for: row)
            case is Tip:            tipSelected(for: row)
            default:                break
            }
        } else {
            flagSelected(for: row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch sampleModel {
        case is TipCategory: return TipCategory(rawValue: row)?.formatted
        case is Tip:         return tips.rank(of: row).text
        default:             return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let model = self.sampleModel {
            switch model.self {
            case is TipCategory: return TipCategory(rawValue: row)?.formatted.string
            case is Tip:
                let str = tips.rank(of: row).text.string
                let index = str.index(str.startIndex, offsetBy: 20)
                
                return String(str[..<index]) + "..."
            default:             return nil
            }
        } else {
            return flagTitle(for: row)
        }
    }
}

// MARK: - Extension: UIPickerViewDataSource

extension FlaggerViewController: UIPickerViewDataSource {
    
    // MARK: - Functions: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let model = self.sampleModel {
            switch model.self {
            case is TipCategory: return TipCategory.max
            case is Tip:         return tips.count
            default:             return 0
            }
        } else {
            return FlagReason.count + 1
        }
    }
}
