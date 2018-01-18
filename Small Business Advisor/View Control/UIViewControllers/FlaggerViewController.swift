//
//  FlaggerViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/16/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud
import CloudKit

class FlaggerViewController: UIViewController, TipEditor {

    // MARK: - Properties
    
    var tip: Tip?

    var flags = MCReceiver<Flag>(db: .publicDB)
    
    var reason: FlagReason?
    
    // When USER has an active flag, returns true.
    var isFlagged: Bool {
        return flags.recordables.contains { $0.creator == MCUserRecord().singleton }
    }
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var flaggerLabel: UILabel!
    
    @IBOutlet weak var flaggerTextField: UITextField!
    
    @IBOutlet weak var flaggerPicker: UIPickerView!
    
    @IBOutlet weak var flagButton: UIButton!
    
    // MARK: - Functions
    
    func decorate() {
        setupFlaggerPicker(for: self)
        
        flaggerTextField.delegate = self
        
        setFlagButtonState()
    }
    
    func setFlagButtonState() {
        if isFlagged {
            flaggerLabel.textColor = .red
//            flagButton.isEnabled = true
        } else {
            flaggerLabel.textColor = .black
//            flagButton.isEnabled = false
        }
        
        flagButton.isEnabled = false
    }
    
    func setupFlaggerPicker(for model: UIPickerViewDataSource & UIPickerViewDelegate) {
        flaggerPicker.delegate = model
        flaggerPicker.dataSource = model
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func flagPressed(_ sender: UIButton) {
        guard reason != nil else { return }
        
        if let tip = self.tip {
            var flag = Flag(tip: tip, for: reason!)
            if let str = flaggerTextField.text { flag.email = str }
            
            let save = MCUpload([flag], from: flags, to: .publicDB)
            let q = OperationQueue()
            q.addOperation(save)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decorate()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flaggerTextField.isEditing { let _ = self.textFieldShouldReturn(flaggerTextField) }
    }
}

extension FlaggerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("EditorVC.pickerView didSelectRow")
        guard tip != nil else { return }
        
        let g = DispatchGroup()
        
        switch row - 1 {
        case 2:
            self.flaggerLabel.text = "Which Tip is this a duplicate of..."

            g.enter()
            let picker = AnyPicker(type: Tip.self, database: .publicDB) { tip in
                self.reason = .duplicate(CKReference(recordID: tip.recordID, action: .deleteSelf))
                g.leave()
            }
            
            setupFlaggerPicker(for: picker)
            self.view.setNeedsDisplay()
            
            g.wait()

            if let reason = self.reason {
                self.flaggerLabel.text = "Flagging as \(reason.toStr())"
            } else {
                self.flaggerLabel.text = "Each user can only have one active flag at a time."
            }
        case 3:
            self.flaggerLabel.text = "Which Category should this tip be..."
            
            g.enter()
            let picker = AnyPicker(type: TipCategory.self, database: .publicDB) { category in
                self.reason = .duplicate(CKReference(recordID: category.recordID, action: .deleteSelf))
                // remove view ? !!
                
                g.leave()
            }

            flaggerPicker.delegate = picker
            flaggerPicker.dataSource = picker
            
            self.view.setNeedsDisplay()
            
            g.wait()
            
            if let reason = self.reason {
                self.flaggerLabel.text = "Flagging as \(reason.toStr())"
            } else {
                self.flaggerLabel.text = "Each user can only have one active flag at a time."
            }

        default:
            switch row {
            case 0: reason = .offTopic
            case 1: reason = .inaccurate
            case 4: reason = .spam
            case 5: reason = .abusive
            default: break
            }
        }

        if !isFlagged { flagButton.isEnabled = true }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
}

extension FlaggerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return FlagReason.count + 1 }
}

extension FlaggerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
