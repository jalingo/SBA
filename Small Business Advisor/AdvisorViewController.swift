//
//  AdvisorViewController.swift
//  Small Business Advisor
//
//  Created by James Lingo on 9/3/17.
//  Copyright © 2017 James Lingo. All rights reserved.
//

import UIKit

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
    var response = ResponseText()
    
    /// `page` stores index of the current entry from the data model, and when set `pageLabel.text` is refreshed.
    var page = 0 {
        didSet { pageLabel.text = String(page) }
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
    @objc override var canBecomeFirstResponder: Bool {
        get { return true }
    }
    
    // MARK: - Functions
    
    /**
        `shakeRoutine` should be run whenever the USER performs shake gesture or swipes to move forward (swiping
        backwards call `decreasePage` instead.
     
        Recognizes `randomSwitch` position, and ensures that page number
        doesn't exceed count (starting over again at page '1').
     */
    fileprivate func shakeRoutine() {
        if randomSwitch.isOn {
            let random = response.byRandom()
            
            textView.attributedText = random
            pageLabel.text = "\(response.lastIndex)"
        } else {
            page < TipFactory.max ? (page += 1) : (page = 1)
            textView.attributedText = response.byIndex(of: page)
        }
    }

    /**
        `decreasePage` should run whenever the USER swipes backward and `randomSwitch` is `off`.
     
        Ensures page doesn't go below '1' (starting over at `TipFactory.max`).
     */
    fileprivate func decreasePage() {
        
        // If in "Random Mode", a swipe is treated as a shake.
        guard !randomSwitch.isOn else { shakeRoutine(); return }
        
        // Else, a swipe right means go back.
        page > 1 ? (page -= 1) : (page = TipFactory.max)
        textView.attributedText = response.byIndex(of: page)
    }
    
    // MARK: - - Functions: IBActions
    
    /// When `randomSwitch` tapped, this populates screen with instructions, based on switch outcome.
    @IBAction func randomSwitched(_ sender: UISwitch) {
        let txt: String
        sender.isOn ? (txt = "Shake for Advice!") : (txt = "Swipe through the various tips...")

        textView.attributedText = NSAttributedString(string: txt, attributes: CategoryFormatting())
    }
    
    /**
        When `helpPressed` this method populates screen with help message and support links.
     
     - Warning: Links are left out of formatting, because `textView` is set to recognize links in text.
     */
    @IBAction func helpPressed(_ sender: UIButton) {
        let txt = "To contact the app's creators with any questions or comments: dev@escapechaos.com\n\nOr, check out our site escapechaos.com/advisor"
        textView.attributedText = NSAttributedString(string: txt, attributes: CategoryFormatting())
    }
    
    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) { shakeRoutine() }

    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) { decreasePage() }
    
    // MARK: - - Functions: UIViewController
    
    /// The only configurations in this override are setting first responder and initializing instruction text.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.attributedText = NSAttributedString(string: "Shake for Advice!", attributes: CategoryFormatting())
        
        self.becomeFirstResponder()
    }
    
    /// This method triggers `shakeRoutine` after USER performs shake gesture.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { shakeRoutine() }
    }
}
