//
//  FieldsEditorViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/8/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import UIKit

class FieldsEditorViewController: UIViewController {

    // MARK: - Properties
    
    var tipBeingEdited: Tip?
    
    fileprivate var category: TipCategory {
        return tipBeingEdited?.category ?? .outOfRange
    }
    
    fileprivate var text: String {
        return tipBeingEdited?.text.string ?? Default.bodyText
    }
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var textArea: UITextView!
    
    // MARK: - Functions
    
    fileprivate func decorateCategory() {
        
    }
    
    fileprivate func saveChanges() {
//        let entry: Entry
        
        if let modifiedTip = tipBeingEdited {   // <-- will submit 'edit'
//            entry = modifiedTip
        } else {                                // <-- nil, will submit 'new'
//            entry = TipSubmission()
        }
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func categoryTapped(_ sender: UIButton) {
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



