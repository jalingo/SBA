//
//  CentralNC.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud

// This class serves as the Navigation controller for the entire app, and stores database mirrors that can be accessed throughout the app.
class CentralNC: UINavigationController {

    // MARK: - Properties

    /// This constant property stores the `Tip` mirror and accessors by rank / random for public database.
    let tips = TipFactory()

    /// This constant property stores the `Vote` mirror for public database.
    let votes = MCMirror<Vote>(db: .publicDB)
    
    /// This constant property stores the `Flag` mirror for public database.
    let flags = MCMirror<Flag>(db: .publicDB)
    
    /// This constant property stores the `TipEdit` mirror for public database.
    let edits = MCMirror<TipEdit>(db: .publicDB)
    
    /// This constant property stores the `Vote` mirror for public database.
    let newTips = MCMirror<NewTip>(db: .publicDB)
    
    // MARK: - Properties: Computed Properties
    
    /// This read-only, computed property returns an array of all suggestions (flags + edits + news).
    var allSuggestions: [SuggestedModeration] {
        var array: [SuggestedModeration] = flags.cloudRecordables
        array += edits.cloudRecordables as [SuggestedModeration] + newTips.cloudRecordables as [SuggestedModeration]
        
        return array
    }

    /// This read-only, computed property returns an array of change notifications matching all mirrors used in `allSuggestions` property.
    var allSuggestionNotifications: [Notification.Name] {
        return [flags.changeNotification, edits.changeNotification, newTips.changeNotification]
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
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
    }
}
