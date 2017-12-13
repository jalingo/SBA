//
//  AnyPicker.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/13/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import MagicCloud

protocol Pickable: MCRecordable {
    var title: String { get }
}

class AnyPicker<T: Pickable>: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    var receiver = MCAnyReceiver<T>(db: .publicDB)
    
    var selectionFollowUp: PickerBlock
    
    // MARK: - Functions
    
    // MARK: - Functions: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return receiver.recordables.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return 1 }
    
    // MARK: - Functions: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let followUp  = selectionFollowUp { followUp(receiver.recordables[row]) }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return receiver.recordables[row].title
    }
    
    // MARK: - Functions: Constuction
    
    init(type: T, database: MCDatabase, didSet: PickerBlock) {
        receiver = MCAnyReceiver<T>(db: database)
        selectionFollowUp = didSet
    }
}
