//
//  FieldsEditorViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/8/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud
import CloudKit

// what if we made this generic...how would we set it? can it be? !!
class FieldsEditorViewController: UIViewController, PickerDecorator {

    // MARK: - Properties
    
    fileprivate var suggestedEdits = MCReceiver<TipEdit>(db: .publicDB)
    
    fileprivate var suggestedTips = MCReceiver<NewTip>(db: .publicDB)
    
    /// When this property is nil, VC is being used to create a new tip suggestion. Otherwise, the stored tip is being edited.
    var tipBeingEdited: Tip?

    // !!
//        {
//        didSet {
//            guard categoryButton != nil else { return }
//print("                                 REACHED !! !! !!")  // <-- Not ever happening...
//            categoryButton.setTitle(category.formatted.string, for: .normal) }
//    }
    
    fileprivate var category: TipCategory { return tipBeingEdited?.category ?? .outOfRange }
    
    fileprivate var text: String { return tipBeingEdited?.text.string ?? Default.bodyText }
    
    fileprivate var selectedCategory: String? {
        didSet {
            if let txt = selectedCategory { categoryButton.setTitle(txt, for: .normal) }
        }
    }
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var editorTypeIndicator: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var textArea: UITextView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties: UIPickerViewDataSource
    
    fileprivate var categories = MCReceiver<TipCategory>(db: .publicDB)
    
    // MARK: - Functions
    
    fileprivate func decorate() {
        if tipBeingEdited == nil { editorTypeIndicator.text = "➕" }
        
        textArea.attributedText = NSAttributedString(string: text, attributes: Format.bodyText)
        textArea.delegate = self
        
        emailField.delegate = self
        
        if let tip = tipBeingEdited {
            categoryButton.setTitle(tip.category.formatted.string, for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if AnyModerator<TipEdit>().isUnderLimit(for: self.suggestedEdits.recordables) {
                    self.saveButton.setTitleColor(.white, for: .normal)
                    self.enableChangesWhileIgnoringFgColor()
                } else {
                    self.disableDatabaseChanges()
                }
            }
        } else {
            categoryButton.setTitle(Default.categoryText, for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if AnyModerator<NewTip>().isUnderLimit(for: self.suggestedTips.recordables) {
                    self.saveButton.setTitleColor(.white, for: .normal)
                    self.enableChangesWhileIgnoringFgColor()
                } else {
                    self.disableDatabaseChanges()
                }
            }
        }
    }
    
    fileprivate func saveChanges() {
        var possibleOp: Operation?
        
        if let tip = tipBeingEdited {                                                   // <-- will submit 'edit'
            var edit = TipEdit(newText: textArea.text, newCategory: selectedCategory, for: tip)
            edit.editorEmail = emailField.text
            
            possibleOp = MCUpload([edit], from: suggestedEdits, to: .publicDB)
        } else {                                                                        // <-- nil, will submit 'new'
            var new = NewTip(text: textArea.text, category: selectedCategory ?? "NA")
            new.editorEmail = emailField.text
            
            possibleOp = MCUpload([new], from: suggestedTips, to: .publicDB)
        }

        if let op = possibleOp { OperationQueue().addOperation(op) }
    }
    
    fileprivate func disableDatabaseChanges() {
        disableChangesWhileIgnoringFgColor()
        saveButton.setTitleColor(.red, for: .normal)
        
        textArea.textColor = .red
        textArea.text = UserFacingText.suggestionLimitExplanation
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func categoryTapped(_ sender: UIButton) {
        let picker = UIPickerView()
        decorate(picker, for: self)
        
        self.view.addSubview(picker)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        saveChanges()
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textArea.isFocused { textArea.resignFirstResponder() }
        if emailField.isEditing { emailField.resignFirstResponder() }
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Functions: Construction
    
    deinit {
        print("** FieldsEditorViewController deinitializing.")
    }
    
    struct Default {
        static let categoryText = "Select Category"
        static let bodyText = UserFacingText.moderatorApprovalExplanation
    }
}

// MARK: - Extensions

// MARK: - Extension: UIPickerViewDataSource

extension FieldsEditorViewController: UIPickerViewDataSource {
    
    /// There is only ever one section (categories)...
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

// MARK: - Extension: UITextViewDelegate

extension FieldsEditorViewController: UITextViewDelegate {
    
    // MARK: - Functions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
}

// MARK: - Extension: UITextFieldDelegate

extension FieldsEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

// MARK: - Extension: ButtonEnabler

extension FieldsEditorViewController: ButtonEnabler {
    var updateButton: UIButton { return saveButton }
}
