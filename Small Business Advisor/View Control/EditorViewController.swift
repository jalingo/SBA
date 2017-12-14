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
    
    let flags = MCAnyReceiver<Flag>(db: .publicDB)
    
    let votes = MCAnyReceiver<Vote>(db: .publicDB)
    
    // MARK: - Functions
    
    fileprivate func vote(up vote: Bool) {
        if let oldVote = previousVote {
            let op = MCDelete([oldVote], of: votes, from: .publicDB)
            OperationQueue().addOperation(op)
        }
        
        if let tip = currentTip, let user = MCUserRecord().singleton {
            let vote = Vote(up: vote,
                            candidate: CKReference(recordID: tip.recordID, action: .deleteSelf),
                            constituent: CKReference(recordID: user, action: .deleteSelf))
            previousVote = vote
            votes.recordables.append(vote)
            
            let op = MCUpload([vote], from: votes, to: .publicDB)
            op.completionBlock = { self.checkAvailability() }    // <-- This should reset vote buttons after
            OperationQueue().addOperation(op)
        }
    }
    
    fileprivate func checkAvailability() {
        let results = votes.recordables.filter { $0.candidate.recordID.recordName == currentTip?.recordID.recordName && $0.constituent.recordID.recordName == MCUserRecord().singleton?.recordName }
        
        if let result = results.last {
            previousVote = result
            upVoteButton.isEnabled = !result.isFor
            downVoteButton.isEnabled = result.isFor
        }
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func upVoteTapped(_ sender: UIButton) { vote(up: true) }
    
    @IBAction func downVoteTapped(_ sender: UIButton) { vote(up: false) }
    
    @IBAction func editTapped(_ sender: UIButton) {
        let vc = FieldsEditorViewController()
        vc.tipBeingEdited = currentTip
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        let vc = FieldsEditorViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func flagTapped(_ sender: UIButton) {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        self.view.addSubview(picker)
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAvailability()
    }

    // MARK: - Functions: Constuction
    
    deinit {
        print("** EditorViewController deinitializing...")
    }
}

// MARK: - Extensions

extension Tip: Pickable {
    var title: String { return self.text.string[0...30] }
}

extension TipCategory: Pickable {
    var title: String { return self.formatted.string }
}

extension EditorViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard currentTip != nil else { return }
        
        var flag = Flag()
        flag.creator = MCUserRecord().singleton
        flag.tip = CKReference(recordID: currentTip!.recordID, action: .deleteSelf)
        
        let g = DispatchGroup()
        
        switch row {
        case 2:
            g.enter()
            let picker = AnyPicker(type: Tip.self, database: .publicDB) { tip in
                flag.reason = .duplicate(CKReference(recordID: tip.recordID, action: .deleteSelf))
                g.leave()
            }
            self.view.addSubview(picker.view)
            g.wait()
        case 3:
            g.enter()
            let picker = AnyPicker(type: TipCategory.self, database: .publicDB) { category in
                flag.reason = .duplicate(CKReference(recordID: category.recordID, action: .deleteSelf))
                // remove view ? !!
                
                g.leave()
            }
            self.view.addSubview(picker.view)
            g.wait()
        default:
            switch row {
            case 0: flag.reason = .offTopic
            case 1: flag.reason = .inaccurate
            case 4: flag.reason = .spam
            case 5: flag.reason = .abusive
            default: break
            }
        }
        
        let op = MCUpload([flag], from: flags, to: .publicDB)
        OperationQueue().addOperation(op)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return "Off Topic / Irrelevant"
        case 1: return "Inaccurate / Disputed"
        case 2: return "Duplicate of..."
        case 3: return "Wrong Category..."
        case 4: return "Spam / Advertisement"
        case 5: return "Abusive / Obscene Content"
        default: return nil
        }
    }
}

extension EditorViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return FlagReason.count }
}
