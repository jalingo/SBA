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

class FieldsEditorViewController: UIViewController {

    // MARK: - Properties
    
    /// When this property is nil, VC is being used to create a new tip suggestion. Otherwise, the stored tip is being edited.
    var tipBeingEdited: Tip? {
        didSet {
            guard categoryButton != nil else { return }
print("                                 REACHED !! !! !!")
            categoryButton.setTitle(category.formatted.string, for: .normal) }
    }
    
    fileprivate var category: TipCategory { return tipBeingEdited?.category ?? .outOfRange }
    
    fileprivate var text: String { return tipBeingEdited?.text.string ?? Default.bodyText }
    
    fileprivate var selectedCategory: String? {
        didSet {
            if let txt = selectedCategory { categoryButton.setTitle(txt, for: .normal) }
        }
    }
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var textArea: UITextView!
    
    // MARK: - Properties: UIPickerViewDataSource
    
    fileprivate var categories = MCReceiver<TipCategory>(db: .publicDB)
    
    // MARK: - Functions
    
    fileprivate func decorateCategory() {
        if let tip = tipBeingEdited {
            categoryButton.setTitle(tip.category.formatted.string, for: .normal)
        } else {
            categoryButton.setTitle(Default.categoryText, for: .normal)
        }
    }
    
    fileprivate func saveChanges() {
        let op: Operation
        
        if let tip = tipBeingEdited {                                                   // <-- will submit 'edit'
            let edit = TipEdit(newText: textArea.text, newCategory: selectedCategory, for: tip)
            op = MCUpload([edit], from: MCReceiver<TipEdit>(db: .publicDB), to: .publicDB)
        } else {                                                                        // <-- nil, will submit 'new'
            let id = CKRecordID(recordName: "New@\(Date().description)")
            let new = NewTip(text: textArea.text, category: selectedCategory ?? "NA", _recordID: id)

            op = MCUpload([new], from: MCReceiver<NewTip>(db: .publicDB), to: .publicDB)
        }

        OperationQueue().addOperation(op)
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func categoryTapped(_ sender: UIButton) {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        self.view.addSubview(picker)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        saveChanges()
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        decorateCategory()
        textArea.attributedText = NSAttributedString(string: text, attributes: Format.bodyText)
        textArea.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textArea.isFocused { textArea.resignFirstResponder() }
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
        static let bodyText =
"""
Tap to edit.

All changes and new tips must be approved by our moderators before they join the list. Tap 'Save' on the keyboard to submit your update.
"""
    }
}

// MARK: - Extensions

// MARK: - Extension: TipEditor

// !!
extension FieldsEditorViewController: TipEditor {
    var tip: Tip? {
        get { return tipBeingEdited }
        set { tipBeingEdited = newValue }
    }
}

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


