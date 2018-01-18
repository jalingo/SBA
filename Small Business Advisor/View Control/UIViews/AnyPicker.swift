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
    
    let receiver: MCReceiver<T>
    
    var selectionFollowUp: PickerBlock
    
    let view: UIPickerView
    
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
    
    init(type: T.Type, database: MCDatabase, didSet: PickerBlock) {
        receiver = MCReceiver<T>(db: database)
        view = UIPickerView()
        selectionFollowUp = didSet
        
        super.init()
        
        view.dataSource = self
        view.delegate = self
    }
}
