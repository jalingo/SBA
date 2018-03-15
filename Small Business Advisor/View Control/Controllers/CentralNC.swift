//
//  CentralNC.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud

// MARK: Class

// This class serves as the Navigation controller for the entire app, and stores database mirrors that can be accessed throughout the app.
class CentralNC: UINavigationController {

    // MARK: - Properties

    /// This optional property stores MCMirror used as data model for `tips` and `votes` computed property.
    var _tips: TipFactory?
    
    /// This computed property stores the `Tip` mirror and accessors by rank / random for public database.
    var tips: [Tip] {
        get { return _tips?.cloudRecordables ?? [] }
        set { _tips?.cloudRecordables = newValue }
    }
    
    /// This constant property stores the `Vote` mirror for public database.
    var votes: [Vote] {
        get { return _tips?.votes.cloudRecordables ?? [] }
        set { _tips?.votes.cloudRecordables = newValue }
    }
    
    /// This optional property stores MCMirror used as data model for `flags` computed property.
    var _flags: MCMirror<Flag>?
    
    /// This constant property stores the `Flag` mirror for public database.
    var flags: [Flag] {
        get { return _flags?.cloudRecordables ?? [] }
        set { _flags?.cloudRecordables = newValue }
    }
    
    /// This optional property stores MCMirror used as data model for `edits` computed property.
    var _edits: MCMirror<TipEdit>?
    
    /// This constant property stores the `TipEdit` mirror for public database.
    var edits: [TipEdit] {
        get { return _edits?.cloudRecordables ?? [] }
        set { _edits?.cloudRecordables = newValue }
    }

    /// This optional property stores MCMirror used as data model for `newTips` computed property.
    var _newTips: MCMirror<NewTip>?
    
    /// This constant property stores the `Vote` mirror for public database.
    var newTips: [NewTip] {
        get { return _newTips?.cloudRecordables ?? [] }
        set { _newTips?.cloudRecordables = newValue }
    }
    
    // MARK: - Properties: Computed Properties
    
    /// This read-only, computed property returns an array of all suggestions (flags + edits + news).
    var allSuggestions: [SuggestedModeration] {
        var array: [SuggestedModeration] = flags
        array += edits as [SuggestedModeration] + newTips as [SuggestedModeration]
        
        return array
    }

    /// This read-only, computed property returns an array of change notifications matching all mirrors used in `allSuggestions` property.
    var allSuggestionNotifications: [Notification.Name] {
        guard let flagNote = _flags?.changeNotification, let editNote = _edits?.changeNotification, let newTip = _newTips?.changeNotification else { return [] }
        return [flagNote, editNote, newTip]
    }
    
    /// This read-only, computed property returns true if USER has associated suggestions, else false.
    var userHasSuggestions: Bool {
        let currentUser = MCUserRecord().singleton
        return allSuggestions.contains { $0.creator == currentUser }
    }
    
    // MARK: - Functions
    
    /// This internal, void method makes NavBar visible and decorates it for `ModerationTableViewController` presentation.
    func decorateForModerationTVC() {
        DispatchQueue.main.async {
            self.isNavigationBarHidden = false
            self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Tall_Header_Green"), for: .defaultPrompt)
        }
    }
    
    /// This fileprivate, void method loads data models with MCMirrors. Activity is asynchronous to prevent nav controller from getting locked up.
    fileprivate func loadDataModels() {
        DispatchQueue(label: "cloud bg").async {
            self._tips = TipFactory()
            self._flags = MCMirror<Flag>(db: .publicDB)
            self._edits = MCMirror<TipEdit>(db: .publicDB)
            self._newTips = MCMirror<NewTip>(db: .publicDB)
        }
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        
        loadDataModels()
    }
}
