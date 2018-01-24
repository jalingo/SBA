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
    
    let tips = TipFactory()
    
    let flags = MCReceiver<Flag>(db: .publicDB)
    
    var reason: FlagReason?
    
    // When USER has an active flag, returns true.
    var isFlagged: Bool { return !AnyModerator<Flag>().isUnderLimit(for: flags.recordables) }
    
    // MARK: - Properties: UIPickerViewDataSource
    
    var sampleModel: Pickable? {
        didSet { flaggerPicker.reloadAllComponents() }
    }
    
    // MARK: - Properties: TipEditor
    
    var tip: Tip?

    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var flaggerLabel: UILabel!
    
    @IBOutlet weak var flaggerTextField: UITextField!
    
    @IBOutlet weak var flaggerPicker: UIPickerView!
    
    @IBOutlet weak var flagButton: UIButton!

    // MARK: - Functions
    
    /// This method updates flaggerLabel and flagButton.
    func updateViews() {
        if let reason = self.reason, !isFlagged {
            self.flaggerLabel.text = "Flagging as \(reason.toStr())."
        } else {
            self.flaggerLabel.text = "Each user can only have one active flag at a time."
        }
        
        self.setFlagButtonState(enabled: !self.isFlagged)
    }
    
    func setFlagButtonState(enabled: Bool) {
        DispatchQueue.main.async {
            if self.isFlagged {
                self.disableChanges()
                self.flaggerLabel.textColor = .red
            } else {
                self.enableChanges()
                if self.flaggerLabel.textColor == .red { self.flaggerLabel.textColor = .black }
            }
        }
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func flagPressed(_ sender: UIButton) {
        guard reason != nil else { return }
        
        if let tip = self.tip {
            var flag = Flag(tip: tip, for: reason!)
            flag.editorEmail = flaggerTextField.text
            
            let save = MCUpload([flag], from: flags, to: .publicDB)
            let q = OperationQueue()
            q.addOperation(save)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flaggerPicker.dataSource = self
        flaggerPicker.delegate = self
        
        flaggerTextField.delegate = self
        
        // This delay gives time for flags to download and draws attention  // <-- !! delay needs to move to MCR init
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.setFlagButtonState(enabled: false) }
        flaggerLabel.attributedText = tip?.text
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flaggerTextField.isEditing { let _ = self.textFieldShouldReturn(flaggerTextField) }
    }
}

// MARK: - Extensions

extension FlaggerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

// !!
extension FlaggerViewController: ButtonEnabler {
    var updateButton: UIButton { return flagButton }
}


