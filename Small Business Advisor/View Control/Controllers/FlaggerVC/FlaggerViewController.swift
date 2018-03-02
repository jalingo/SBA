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

/// This sub-class inherits from UIViewController, and manages USER's ability to flag tips for removal / correction.
@IBDesignable
class FlaggerViewController: UIViewController, TipEditor {

    // MARK: - Properties
    
    /// This property stores an MCReceiver associated w/Tip recordable.
    /// Access an array of all existing types in .recordables
    let tips = TipFactory()
    
    /// This property stores an MCReceiver associated w/Flag recordable.
    /// Access an array of all existing types in .recordables
    let flags = MCMirror<Flag>(db: .publicDB)
    
    /// This optional property is set when a reason for flagging tip specified by USER. Otherwise, is nil.
    var reason: FlagReason?
    
    /// When USER has an active flag, returns true.
    var isFlagged: Bool { return !AnyModerator<Flag>().isUnderLimit(for: flags.cloudRecordables) }
    
    // MARK: - Properties: UIPickerViewDataSource
    
    /// This optional property is accessed by UIPickerViewDataSource to determine model info to load.
    var sampleModel: Pickable? {
        didSet { flaggerPicker.reloadAllComponents() }
    }
    
    // MARK: - Properties: TipEditor
    
    /// This optional property references the tip being flagged by the USER.
    var tip: Tip?

    // MARK: - Properties: IBOutlets
    
    /// This IBOutlet property references the main label used to communicate with USER.
    @IBOutlet weak var flaggerLabel: UILabel!

    /// This IBOutlet property references the text field USER can input email address in.
    @IBOutlet weak var flaggerTextField: UITextField!
    
    /// This IBOutlet property references the pickerView used to select FlagReason.
    @IBOutlet weak var flaggerPicker: UIPickerView!
    
    /// This IBOutlet property references the button used to save configured flag to database.
    @IBOutlet weak var flagButton: UIButton!

    // MARK: - Functions
    
    /// This method updates flaggerLabel and flagButton.
    func updateViews() {
        
        // prevents update when no network connectivity
        guard tips.count != 0 else { return }
        
        if let reason = self.reason, !isFlagged {
            self.flaggerLabel.text = "Flagging as \(reason.toStr())."
        } else {
            self.flaggerLabel.text = UserFacingText.flagLimitExplanation
        }
        
        self.setFlagButtonState(enabled: !self.isFlagged)
    }
    
    /**
        This method sets flag button's state to match passed condition.
     
        - Parameter enabled: The argument for button's enabled (true) or disabled (false) state and corresponding color.
     */
    fileprivate func setFlagButtonState(enabled: Bool) {
        DispatchQueue.main.async {
            if self.isFlagged {
                self.disableChangesWhileIgnoringFgColor()
                self.flaggerLabel.textColor = .red
            } else {
                self.enableChangesWhileIgnoringFgColor()
                if self.flaggerLabel.textColor == .red { self.flaggerLabel.textColor = .black }
            }
        }
    }
    
    /// This method sets delegates for various UIKit components.
    fileprivate func delegation() {
        flaggerPicker.dataSource = self
        flaggerPicker.delegate = self
        
        flaggerTextField.delegate = self
    }
    
    // MARK: - Functions: IBActions
    
    /// This IBAction method saves flag to database when USER taps sender.
    @IBAction func flagPressed(_ sender: UIButton) {
        guard reason != nil else { return }
        
        if let tip = self.tip {
            var flag = Flag(tip: tip, for: reason!)
            flag.editorEmail = flaggerTextField.text
            
            flags.cloudRecordables.append(flag)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegation()
        
        // This delay gives time for flags to download and draws attention cloud update reception.
        // CAUTION: Currently, flagger view cannot be reached without network connectivity already being established. In the event of a connectivity loss, this could loop infinitely.
        DispatchQueue(label: "delay").async {
            while self.flags.cloudRecordables.count == 0 { /* wait until tips have been downloaded */ } // Then...
            DispatchQueue.main.async { self.setFlagButtonState(enabled: false) }
        }
        
        if let txt = tip?.text[...65] {
            let mutableVersion = NSMutableAttributedString(attributedString: txt)
            mutableVersion.mutableString.setString(txt.string + "...")
            flaggerLabel.attributedText = mutableVersion
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flaggerTextField.isEditing { let _ = self.textFieldShouldReturn(flaggerTextField) }
    }
}

// MARK: - Extensions

// MARK: - Extension: UITextFieldDelegate

extension FlaggerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

// MARK: - Extension: ButtonEnabler

extension FlaggerViewController: ButtonEnabler {
    var updateButton: UIButton { return flagButton }
}


