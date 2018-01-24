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
    
    var currentTip: Tip?
    
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
print("EditorVC.vote")
        if let oldVote = previousVote {
            let op = MCDelete([oldVote], of: votes, from: .publicDB)
            OperationQueue().addOperation(op)
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
print("EditorVC.checkAvailability")
        if let user = MCUserRecord().singleton?.recordName {
            let results = votes.recordables.filter {
                $0.candidate.recordID.recordName == currentTip?.recordID.recordName &&
                    $0.constituent.recordID.recordName == user }
            
            if let result = results.last {
                previousVote = result
                upVoteButton.isEnabled = !result.isFor
                downVoteButton.isEnabled = result.isFor
            }
        }
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
        checkAvailability()
    }
    
// MARK: - Functions: Constuction !!
    
deinit { print("EditorViewController.deinit") }
required init?(coder aDecoder: NSCoder) { print("EditorVC.init coder"); super.init(coder: aDecoder) }
}

// MARK: - Extensions !! rm pickable?

extension Tip: Pickable {
    var title: String { return self.text.string[0...30] }
}

extension TipCategory: Pickable {
    var title: String { return self.formatted.string }
}
