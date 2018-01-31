//
//  TipEditor.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/26/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import Foundation

// MARK: Protocol

/// This protocol should be conformed by any view controller that wants to recieve the current tip during a segue from AdvisorViewController (or any other controller passing a tip to be edited / reviewed).
protocol TipEditor: AnyObject {
    
    /// This optional property will be set when local view controller is destination for AdvisorViewController.
    var tip: Tip? { get set }
}

// MARK: - Extensions

// MARK: - Extension: EditorViewController

extension EditorViewController: TipEditor {
    
    /// This optional property will be set when local view controller is destination for AdvisorViewController.
    var tip: Tip? {
        get { return currentTip }
        set { currentTip = newValue }
    }
}

// MARK: - Extension: FlaggerViewController

    // Conformed in class declaration.

// MARK: - Extension: FieldsEditorViewController

extension FieldsEditorViewController: TipEditor {

    /// This optional property will be set when local view controller is destination for AdvisorViewController.
    var tip: Tip? {
        get { return tipBeingEdited }
        set { tipBeingEdited = newValue }
    }
}
