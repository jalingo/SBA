//
//  EditorViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/8/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

// MARK: Imports

import UIKit
import MagicCloud
import CloudKit

// MARK: - Class: EditorViewController

/// This view controller is a child of AdvisorViewController and contains voting and moderation buttons.
class EditorViewController: UIViewController {

    // MARK: - Properties
    
    /// This optional property stores the current tip being modified by voting and moderation buttons.
    var currentTip: Tip? {
        didSet {
            previousVote = nil
            if currentTip?.text.string != Tip.defaultText { checkAvailability() }
        }
    }
    
    /// This optional property stores the last vote cast for currentTip. If no vote has been cast, is nil.
    var previousVote: Vote?
    
    // MARK: - Properties: IBOutlets
    
    /// This IBOutlet property stores a button that can be used to vote for currentTip, or undo.
    @IBOutlet weak var upVoteButton: UIButton!
    
    /// This IBOutlet property stores a button that can be used to vote against currentTip, or undo.
    @IBOutlet weak var downVoteButton: UIButton!
    
    /// This IBOutlet property stores a button that can be used to present FieldsEditorVC to create a new tip.
    @IBOutlet weak var addTipButton: UIButton!
    
    /// This IBOutlet property stores a button that can be used to present FieldsEditorVC to edit currentTip.
    @IBOutlet weak var editTipButton: UIButton!
    
    /// This IBOutlet property stores a button that can be used to present FlaggerVC to flag currentTip.
    @IBOutlet weak var flagTipButton: UIButton!
    
    // MARK: - Properties: UIPickerView
    
    /// This property stores an MCReceiver associated w/Flag recordable.
    /// To access an array of all existing types in .recordables
    var flags = MCMirror<Flag>(db: .publicDB)
    
    /// This property stores an MCReceiver associated w/Vote recordable.
    /// To access an array of all existing types in .recordables
    var votes = MCMirror<Vote>(db: .publicDB)

    // MARK: - Functions
    
    /**
        This method casts a vote for the currentTip for the USER. To do so, it deletes any existing vote USER may have cast for currentTip, and then writes a new vote based on the direction passed as vote parameter.
     
        - Parameter vote: A boolean indicating whether vote is for (true) or against (false).
     */
    fileprivate func vote(up vote: Bool) {

        // First need to remove any existing vote, if there...
        removeExisting(vote)

        // Before proceeeding, need to check for undo situation...
        guard previousVote == nil else {
            
            // After undoing vote, reset states
            adjustVoteButtonStatesForReset(enabled: true)
            previousVote = nil
            
            return
        }
        
        // Save new vote to the database.
        cast(vote)
    }

    /**
        This method removes any existing votes, if they already exist, and checks for undo situation (when vote direction was already cast, and USER is tapping button in order to 'undo' that vote).
     
        - Parameter vote: A boolean indicating whether vote is for (true) or against (false).
     */
    fileprivate func removeExisting(_ vote: Bool) {
        if let oldVote = previousVote {
            let op = MCDelete([oldVote], of: votes, from: .publicDB)
            OperationQueue().addOperation(op)
            
            // This constraint can signal undo situation, when not set nil
            if oldVote.isFor != vote { previousVote = nil }
        }
    }
    
    /**
        Saves new vote by USER for currentTip to the database, based on vote passed.

        - Parameter vote: A boolean indicating whether vote is for (true) or against (false).
     */
    fileprivate func cast(_ vote: Bool) {
        if let tip = currentTip, let user = MCUserRecord().singleton {
            let vote = Vote(up: vote,
                            candidate: CKReference(recordID: tip.recordID, action: .deleteSelf),
                            constituent: CKReference(recordID: user, action: .deleteSelf))
            previousVote = vote
            
            let op = MCUpload([vote], from: votes, to: .publicDB)
            op.completionBlock = { self.checkAvailability() }    // <-- This should reset vote buttons after
            OperationQueue().addOperation(op)
        }
    }
    
    /// This method checks database for any existing vote that matches this USER and currentTip.
    fileprivate func checkAvailability() {
        if let user = MCUserRecord().singleton?.recordName {
            switchButtons(visible: true)
            
            let results = votes.cloudRecordables.filter {
                $0.candidate.recordID.recordName == currentTip?.recordID.recordName &&
                    $0.constituent.recordID.recordName == user }

            if let result = results.last { previousVote = result }
            
            // if results.last == nil, button states will be reset; otherwise set to match result.
            DispatchQueue.main.async { self.adjustVoteButtonStates(for: results.last) }
        } else {
            switchButtons(visible: false)
        }
    }
    
    /**
        This method adjust button state (including display configuration and isEnabled) based on USER's vote for currentTip.
     
        - Parameter result: Argument representing USER's vote for currentTip (or lack of vote if nil).
     */
    fileprivate func adjustVoteButtonStates(for result: Vote?) {
        if let result = result {
            adjustVote(button: upVoteButton, enable: !result.isFor)
            adjustVote(button: downVoteButton, enable: result.isFor)
        } else {
            
            // This gracefully disables cloud features that require an account.
            adjustVoteButtonStatesForReset(enabled: true)
        }
    }
    
    /**
        This method adjust button visibility for the entire editor row together.
     
        - Parameter visible: Argument representing whether method should make buttons visible (true), or not (false).
     */
    fileprivate func switchButtons(visible: Bool) {
        DispatchQueue.main.async {
            self.upVoteButton.isHidden =   !visible
            self.downVoteButton.isHidden = !visible
            self.addTipButton.isHidden =   !visible
            self.editTipButton.isHidden =  !visible
            self.flagTipButton.isHidden =  !visible
        }
    }
    
    /**
        This method adjusts button state (including display configurationand isEnabled) in accordance with a reset situation (no vote exists).
     
        - Parameter enabled: Argument indicating if buttons should both be enabled (true) or disabled (false).
     */
    fileprivate func adjustVoteButtonStatesForReset(enabled: Bool) {
        adjustVote(button: upVoteButton, enable: enabled)
        adjustVote(button: downVoteButton, enable: enabled)
        
        upVoteButton.isEnabled = enabled
        downVoteButton.isEnabled = enabled
    }
    
    /**
         This method adjusts the button passed to match the enabled state passed.
     
        - Parameters:
            - button: The vote button (up or down) that is being adjusted.
            - enable: The state to adjust button for. If true, button will be enabled, else disabled.
     */
    fileprivate func adjustVote(button: UIButton, enable: Bool) {
        enable ? button.setTitleColor(Format.ecGreen, for: .normal) : button.setTitleColor(.gray, for: .normal)
        button.isEnabled = true // <-- This ensure that false state from adjustVoteButtonStatesForReset:enabled:false is corrected if encountered.
    }
    
    /**
        This method will trigger segue from the parent view controller.
     
        - Parameter id: The identifier of the segue that should be triggered.
     */
    func segue(from id: String) { self.parent?.performSegue(withIdentifier: id, sender: nil) }

    // MARK: - Functions: IBActions
    
    /// This IBAction method triggers an up vote situation in vote:up: method.
    @IBAction func upVoteTapped(_ sender: UIButton) { vote(up: true) }
    
    /// This IBAction method triggers a down vote situation in vote:up: method.
    @IBAction func downVoteTapped(_ sender: UIButton) { vote(up: false) }
    
    /// This method checks that AdvisorVC has a page value and that there's no network error (defaultText).
    @IBAction func editTapped(_ sender: UIButton) {
        if let parent = self.parent as? AdvisorViewController, parent.page != 0, currentTip?.text.string != Tip.defaultText { segue(from: "homeToEditor") }
    }
    
    /// This method checks that there's no network error (defaultText).
    @IBAction func addTapped(_ sender: UIButton) {
        if let parent = self.parent as? AdvisorViewController,
            parent.page == 0 || currentTip?.text.string != Tip.defaultText, // <- first page or no net errors
            parent.tips.count != 0      // <-- This ensures that first page fails w/network errors
        {
            parent.tipPassingAllowed = false
            segue(from: "homeToEditor")
        }
    }
    
    /// This method checks that AdvisorVC has a page value and that there's no network error (defaultText).
    @IBAction func flagTapped(_ sender: UIButton) {
        if let parent = self.parent as? AdvisorViewController, parent.page != 0, currentTip?.text.string != Tip.defaultText { self.segue(from: "homeToFlagger") }
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentTip?.index == -1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { self.adjustVoteButtonStatesForReset(enabled: false) }
        } else {
            self.checkAvailability()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.CKAccountChanged, object: nil, queue: nil) { note in
            self.checkAvailability()
        }
    }
}
