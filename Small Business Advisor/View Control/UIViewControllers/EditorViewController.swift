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

class EditorViewController: UIViewController {

    // MARK: - Properties
    
    var currentTip: Tip? {
        didSet {
            previousVote = nil
            checkAvailability()
        }
    }
    
    var previousVote: Vote?
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var upVoteButton: UIButton!
    
    @IBOutlet weak var downVoteButton: UIButton!
    
    @IBOutlet weak var addTipButton: UIButton!
    
    @IBOutlet weak var editTipButton: UIButton!
    
    @IBOutlet weak var flagTipButton: UIButton!
    
    // MARK: - Properties: UIPickerView
    
    var flags = MCReceiver<Flag>(db: .publicDB)
    
    var votes = MCReceiver<Vote>(db: .publicDB)

    // MARK: - Functions
    
    fileprivate func vote(up vote: Bool) {
        if let oldVote = previousVote {
            let op = MCDelete([oldVote], of: votes, from: .publicDB)
            OperationQueue().addOperation(op)
            
            // this constraint can signal undo situation, when not set nil
            if oldVote.isFor != vote { previousVote = nil }
        }

        // before proceeeding, need to check for undo situation...
        guard previousVote == nil else {
            
            // After undoing vote, reset states
            adjustVoteButtonStatesForReset(enabled: true)
            previousVote = nil
            
            return
        }
        
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
    
    fileprivate func checkAvailability() {
        if let user = MCUserRecord().singleton?.recordName {
            let results = votes.recordables.filter {
                $0.candidate.recordID.recordName == currentTip?.recordID.recordName &&
                    $0.constituent.recordID.recordName == user }

            if let result = results.last { previousVote = result }
            
            // if results.last == nil, button states will be reset; otherwise set to match result.
            DispatchQueue.main.async { self.adjustVoteButtonStates(for: results.last) }
        }
    }
    
    fileprivate func adjustVoteButtonStates(for result: Vote?) {
        if let result = result {
            adjustVote(button: upVoteButton, enable: !result.isFor)
            adjustVote(button: downVoteButton, enable: result.isFor)
        } else {
            adjustVoteButtonStatesForReset(enabled: true)
        }
    }
    
    fileprivate func adjustVoteButtonStatesForReset(enabled: Bool) {
        adjustVote(button: upVoteButton, enable: enabled)
        adjustVote(button: downVoteButton, enable: enabled)
    }
    
    fileprivate func adjustVote(button: UIButton, enable: Bool) {
        enable ? button.setTitleColor(Format.ecGreen, for: .normal) : button.setTitleColor(.gray, for: .normal)
    }
    
    func segue(from id: String) { self.parent?.performSegue(withIdentifier: id, sender: nil) }

    // MARK: - Functions: IBActions
    
    @IBAction func upVoteTapped(_ sender: UIButton) { vote(up: true) }
    
    @IBAction func downVoteTapped(_ sender: UIButton) { vote(up: false) }
    
    @IBAction func editTapped(_ sender: UIButton) {
        if let parent = self.parent as? AdvisorViewController, parent.page != 0 { segue(from: "homeToEditor") }   // <- How do I differentiate w/out currentTip & still need currentTip ?
    }
    
    // restraint not needed, can add from the get go.
    @IBAction func addTapped(_ sender: UIButton) {
        if let parent = self.parent as? AdvisorViewController { parent.tipPassingAllowed = false }
        segue(from: "homeToEditor") }                                  // <- How do I differentiate w/out currentTip & still need currentTip ?
    
    @IBAction func flagTapped(_ sender: UIButton) {
        if let parent = self.parent as? AdvisorViewController, parent.page != 0 { self.segue(from: "homeToFlagger") }
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentTip?.index == -1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { self.adjustVoteButtonStatesForReset(enabled: false) }
        } else {
            self.checkAvailability()
        }
    }
    
// MARK: - Functions: Constuction !!
    
deinit { print("   EditorViewController.deinit") }
required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); print("   EditorVC.init coder \(String(describing: self.nibName))") }
}

// MARK: - Extension: TipEditor

extension EditorViewController: TipEditor {
    var tip: Tip? {
        get { return currentTip }
        set { currentTip = newValue }
    }
}