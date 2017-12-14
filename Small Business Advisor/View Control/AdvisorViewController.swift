//
//  AdvisorViewController.swift
//  Small Business Advisor
//
//  Created by James Lingo on 9/3/17.
//  Copyright © 2017 James Lingo. All rights reserved.
//

import UIKit
import MagicCloud

// MARK: Class

/**
   The `AdvisorViewController` is the only view controller for the entire app. It handles all user interactions
   (swipes, shakes and taps) and displays the appropriate strings harvested from the data model: `ResponseText`.
 */
class AdvisorViewController: UIViewController {
    
    // MARK: - Properties
    
    /**
       `response` will be used to provide the correct info from the data model (category and body strings now, but
       eventually ratings and thread links too).
     */
//    var response = ResponseText()
    
    var tips = _TipFactory(db: .publicDB)
    
    /// `page` stores index of the current entry from the data model, and when set `pageLabel.text` is refreshed.
    var page = 0 {
        didSet { pageLabel.text = String(page) }
    }

    // MARK: - - Properties: ReceivesRecordable
    
    // !!
    var subscription = MCSubscriber(forRecordType: Tip().recordType)
    
    // !!
    var recordables = [TipCategory]() {
        didSet { print("** AVC.recordables didSet: \(recordables.count)") }
    }
    
    // MARK: - - Properties: IBOutlets
    
    /// `pageLabel` shows the index of the current entry from the data model.
    @IBOutlet weak var pageLabel: UILabel!
    
    /// `textView` shows the body text from the current entry from the data model.
    @IBOutlet weak var textView: UITextView!
    
    /// `randomSwitch` is toggled between `on` (next entry determined at random) & `off` (entries come in order).
    @IBOutlet weak var randomSwitch: UISwitch!
    
    // MARK: - - Properties: UIResponder
    
    /// This override allows `AdvisorViewController` to become first responder (to user interactions); always true.
    @objc override var canBecomeFirstResponder: Bool { return true }
    
    // MARK: - Functions
    
    /**
        `increasePage` should be run whenever the USER performs shake gesture or swipes to move forward (swiping
        backwards call `decreasePage` instead.
     
        Recognizes `increasePage` position, and ensures that page number doesn't exceed count (starting over again
        at page '1').
     */
    fileprivate func increasePage() {
        if randomSwitch.isOn {
            if let random = tips.random() {
                textView.attributedText = random.text
                page = tips.lastRank
            }
          
        } else {
            page < tips.count ? (page += 1) : (page = 1)
            if let tip = tips.rank(of: page) { textView.attributedText = tip.text }
        }
    }

    /**
        `decreasePage` should run whenever the USER swipes backward and `randomSwitch` is `off`.
     
        Ensures page doesn't go below '1' (starting over at `TipFactory.max`).
     */
    fileprivate func decreasePage() {
        
        // If in "Random Mode", a swipe is treated as a shake.
        guard !randomSwitch.isOn else { increasePage(); return }
        
        // Else, a swipe right means go back.
        page > 1 ? (page -= 1) : (page = tips.count)
        if let tip = tips.rank(of: page) { textView.attributedText = tip.text }
    }
    
    // MARK: - - Functions: IBActions
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) { /* May need to reload view here... */ }
    
    @IBAction func logoTapped(_ sender: UIButton) {
        if let url = URL(string: URL_str.homePage) { UIApplication.shared.open(url) }
    }
    
    /// When `randomSwitch` tapped, this populates screen with instructions, based on switch outcome.
    @IBAction func randomSwitched(_ sender: UISwitch) {
        let txt: String
        sender.isOn ? (txt = Instructions.shake) : (txt = Instructions.swipe)

        textView.attributedText = NSAttributedString(string: txt, attributes: CategoryFormatting())
    }
    
    /**
        When `helpPressed` this method populates screen with help message and support links.
     
     - Warning: Links are left out of formatting, because `textView` is set to recognize links in text.
     */
    @IBAction func helpPressed(_ sender: UIButton) {
        textView.attributedText = NSAttributedString(string: Instructions.help,
                                                     attributes: CategoryFormatting())
    }
    
    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) { increasePage() }

    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) { decreasePage() }
    
    // MARK: - - Functions: UIViewController
    
    /// The only configurations in this override are setting first responder and initializing instruction text.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.attributedText = NSAttributedString(string: Instructions.shake,
                                                     attributes: CategoryFormatting())
        
        subscribeToChanges(on: .publicDB)
        
        self.becomeFirstResponder()
    }
    
    /// This method triggers `shakeRoutine` after USER performs shake gesture.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { increasePage() }
    }
}

// MARK: - Extensions

extension AdvisorViewController: MCReceiverAbstraction {
    typealias type = TipCategory
}
