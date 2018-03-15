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

/// This view controller is presented by AdvisorVC when either USER requests to create a new tip (tipBeingEdited is nil) or edit an existing tip (tipBeingEdited != nil).
class FieldsEditorViewController: UIViewController, PickerDecorator {

    // MARK: - Properties

    /// This property stores an MCReceiver associated w/TipEdit recordable.
    /// To access an array of all existing types in .cloudRrecordables
    fileprivate var suggestedEdits: MCMirror<TipEdit>? {
        guard let nav = self.navigationController as? CentralNC else { return nil }
        return nav._edits
    }
    
    /// This property stores an MCReceiver associated w/NewTip recordable.
    /// To access an array of all existing types in .cloudRecordables
    fileprivate var suggestedTips: MCMirror<NewTip>? {
        guard let nav = self.navigationController as? CentralNC else { return nil }
        return nav._newTips
    }
    
    /// This computed property returns the category of the tipBeingEdited, or if nil then ".outOfRange".
    fileprivate var category: TipCategory { return tipBeingEdited?.category ?? .outOfRange }
    
    /// This computed property returns the body text for the tipBeingEdited, or if nil then "Default.bodyText".
    fileprivate var text: String { return tipBeingEdited?.text.string ?? Default.bodyText }
    
    /// When this property is nil, VC is being used to create a new tip suggestion. Otherwise, the stored tip is being edited.
    var tipBeingEdited: Tip?
    
    /// This optional property stores new category selected, or nil if USER has not made a selection.
    var selectedCategory: String? {
        didSet {
            if let txt = selectedCategory { categoryButton.setTitle(txt, for: .normal) }
        }
    }
    
    // MARK: - Properties: IBOutlets
    
    /// This IBOutlet property references a label that indicates type of editor: create new v. edit existing.
    @IBOutlet weak var editorTypeIndicator: UIImageView!
    
    /// This IBOutlet property references the category button used to display current category and tap for more.
    @IBOutlet weak var categoryButton: UIButton!
    
    /// This IBOutlet property references the textArea used to communicate with USER.
    @IBOutlet weak var textArea: UITextView!
    
    /// This IBOutlet property references the save button USER taps to save changes they've made.
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties: UIPickerViewDataSource
    
    /// This property stores an MCReceiver associated w/TipCategory recordable.
    /// Access an array of all existing types in .recordables
    var categories = MCMirror<TipCategory>(db: .publicDB)
    
    // MARK: - Functions
    
    /// This method decorates UI elements based on tipBeingEdited.
    fileprivate func decorate() {
        if tipBeingEdited == nil { editorTypeIndicator.image = #imageLiteral(resourceName: "Add_white") }
        
        textArea.attributedText = NSAttributedString(string: text, attributes: Format.bodyText)
        textArea.delegate = self
        
        decorateButtons()
    }
    
    /// This method decorates buttons from view based on tipBeingEdited.
    fileprivate func decorateButtons() {
        if let tip = tipBeingEdited {
            categoryButton.setTitle(tip.category.formatted.string, for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let suggestedEdits = self.suggestedEdits else { return }

                if AnyModerator<TipEdit>().isUnderLimit(for: suggestedEdits.cloudRecordables) {
                    self.saveButton.setTitleColor(.white, for: .normal)
                    self.enableChangesWhileIgnoringFgColor()
                } else {
                    self.disableDatabaseChanges()
                }
            }
        } else {
            categoryButton.setTitle(Default.categoryText, for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let suggestedTips = self.suggestedTips else { return }

                if AnyModerator<NewTip>().isUnderLimit(for: suggestedTips.cloudRecordables) {
                    self.saveButton.setTitleColor(.white, for: .normal)
                    self.enableChangesWhileIgnoringFgColor()
                } else {
                    self.disableDatabaseChanges()
                }
            }
        }
    }
    
    /// This method saves changes made by USER to tipBeingEdited or new tip to be created.
    fileprivate func saveChanges() {
        if let tip = tipBeingEdited {
            let edit = TipEdit(newText: textArea.text, newCategory: selectedCategory, for: tip)
            suggestedEdits?.cloudRecordables.append(edit)
        } else {
            let new = NewTip(text: textArea.text, category: selectedCategory ?? "NA")  
            suggestedTips?.cloudRecordables.append(new)
        }
    }
    
    /// This method disables buttons that allow USER to interact with database.
    fileprivate func disableDatabaseChanges() {
        disableChangesWhileIgnoringFgColor()
        saveButton.setTitleColor(.red, for: .normal)
        
        textArea.textColor = .red
        textArea.text = UserFacingText.suggestionLimitExplanation
    }
    
    // MARK: - Functions: IBActions
    
    /// This IBAction method adds a category pickerView as subView when sender is tapped.
    @IBAction func categoryTapped(_ sender: UIButton) {
        let picker = UIPickerView()
        decorate(picker, for: self)
        
        self.view.addSubview(picker)
    }

    /// This IBAction method saves changes and unwindes back to AdvisorVC when sender is tapped.
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
    }

    // MARK: - Inner Classes
    
    /// This struct contains default strings for User Facing text in view controller.
    struct Default {
        static let categoryText = "Select Category"
        static let bodyText = UserFacingText.moderatorApprovalExplanation
    }
}

// MARK: - Extensions

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

// MARK: - Extension: ButtonEnabler

extension FieldsEditorViewController: ButtonEnabler {
    var updateButton: UIButton { return saveButton }
}
