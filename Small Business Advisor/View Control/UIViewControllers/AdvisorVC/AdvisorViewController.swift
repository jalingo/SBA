//
//  AdvisorViewController.swift
//  Small Business Advisor
//
//  Created by James Lingo on 9/3/17.
//  Copyright © 2017 James Lingo. All rights reserved.
//

import UIKit
import MagicCloud

// MARK: - Class

/**
    The `AdvisorViewController` is the primary view controller for the entire app. It handles all user interactions (swipes, shakes and taps) and displays the appropriate strings harvested from the data model: `ResponseText`.
 
    It contains `EditorViewController` as a child view controller and can segue to `FlaggerVC` and `FieldsEditorVC` for list moderation suggestions.
 */
class AdvisorViewController: UIViewController, PickerDecorator {
    
    // MARK: - Properties
    
    /// This receiver is the primary connection to the data model. Handles vote counting locally.
    /// Access an array of all existing types in .recordables
    var tips = TipFactory()
    
    /// This boolean can be used to prevent AdvisorVC from passing tip to TipEditor in AdvisorVC.prepare:forSegue:
    var tipPassingAllowed = true
    
    /// `page` stores index of the current entry from the data model, and when set `pageLabel.text` is refreshed.
    var page = 0 {
        didSet {
            categoryLock.isEnabled = true
            pageLabel.text = String(page)

            if tips.cloudRecordables.count != 0 { passTipToChildren() }
            
            selectCategoryButton.setAttributedTitle(tips.rank(of: page).category.formatted, for: .normal)
        }
    }
    
    // MARK: - - Properties: IBOutlets
    
    /// `pageLabel` shows the rank of the current entry from the data model.
    @IBOutlet weak var pageLabel: UILabel!
    
    /// `textView` shows the body text from the current entry from the data model.
    @IBOutlet weak var textView: UITextView!
    
    /// `randomSwitch` is toggled between `on` (next entry determined at random) & `off` (entries come in order).
    @IBOutlet weak var randomSwitch: UISwitch!
    
    /// This IBOutlet property displays current tip's category and serves a button to limit list by category.
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    /// This IBOutlet property displays category lock status and switchs category limitation state.
    @IBOutlet weak var categoryLock: UIButton!
    
    // MARK: - - Properties: UIResponder
    
    /// This override allows `AdvisorViewController` to become first responder (to user interactions); always true.
    @objc override var canBecomeFirstResponder: Bool { return true }
    
    // MARK: - Functions
    
    /// This method presents a pickerView representing categories when USER specifies category limitation.
    fileprivate func pick() {
        let picker = UIPickerView()
        decorate(picker, for: self)
        
        view.addSubview(picker)
    }
    
    /// This method will pass current tip to any child view controllers conforming to TipEditor (see above).
    fileprivate func passTipToChildren() {
        for child in childViewControllers {
            if let controller = child as? TipEditor { tipPassingAllowed ? (controller.tip = tips.rank(of: page)) : (tipPassingAllowed = true) }
        }
    }
    
    /**
        `increasePage` should be run whenever the USER performs shake gesture or swipes to move forward (swiping backwards call `decreasePage` instead).
     
        Recognizes `increasePage` position, and ensures that page number doesn't exceed count (starting over again at page '1').
     */
    func increasePage() {
        if randomSwitch.isOn {
            let random = tips.random()
            textView.attributedText = random.text
            page = tips.lastRank
        } else {
            page < tips.count ? (page += 1) : (page = 1)
            textView.attributedText = tips.rank(of: page).text
        }
    }

    /**
        `decreasePage` should run whenever the USER swipes backward and `randomSwitch` is `off`.
     
        Ensures page doesn't go below '1' (starting over at `TipFactory.max`).
     */
    func decreasePage() {
        
        // If in "Random Mode", a swipe is treated as a shake.
        guard !randomSwitch.isOn else { increasePage(); return }
        
        // Else, a swipe right means go back.
        page > 1 ? (page -= 1) : (page = tips.count)
        textView.attributedText = tips.rank(of: page).text
    }
    
    // MARK: - - Functions: IBActions
    
    /// This IBAction method is used by other view controllers to unwind back to AdvisorViewController.
    @IBAction func unwindToHome(segue: UIStoryboardSegue) { /* May need to reload view here... */ }
    
    /// This IBAction method exits the app and opens browser (w/specified site) when user taps logo.
    @IBAction func logoTapped(_ sender: UIButton) {
        if let url = URL(string: URL_str.homePage) { UIApplication.shared.open(url) }
    }
    
    /// When `randomSwitch` tapped, this populates screen with instructions, based on switch outcome.
    @IBAction func randomSwitched(_ sender: UISwitch) {
        let txt: String
        sender.isOn ? (txt = UserFacingText.shakeInstructions) : (txt = UserFacingText.swipeInstructions)

        textView.attributedText = NSAttributedString(string: txt, attributes: Format.categoryTitle)
    }
    
    /**
        When `helpPressed` this method populates screen with help message and support links.
     
        - Warning: Links are left out of formatting, because `textView` is set to recognize links in text.
     */
    @IBAction func helpPressed(_ sender: UIButton) {
        textView.attributedText = NSAttributedString(string: UserFacingText.helpInstructions,
                                                     attributes: Format.categoryTitle)
    }
    
    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) { increasePage() }

    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) { decreasePage() }
    
    /// This IBAction method switches category limitation lock state when user taps category lock button.
    @IBAction func categoryLockTapped(_ sender: UIButton) {
        if let _ = tips.limitation {
            tips.limitation = nil
            sender.setTitle("🔐", for: .normal)
            selectCategoryButton.isEnabled = false
        } else {
            tips.limitation = tips.rank(of: tips.lastRank).category
            sender.setTitle("🔒", for: .normal)
            selectCategoryButton.isEnabled = true
        }
        
        sender.setNeedsDisplay()
    }
    
    /// This IBAction method presents category pickerView selector when category limited and USER taps.
    @IBAction func categorySelectorTapped(_ sender: UIButton) { pick() }
    
    // MARK: - - Functions: UIViewController
    
    /// The only configurations in this override are setting first responder and initializing instruction text.
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributedText = NSAttributedString(string: UserFacingText.shakeInstructions,
                                                     attributes: Format.categoryTitle)
        
        self.becomeFirstResponder()
    }
    
    /// This method triggers `shakeRoutine` after USER performs shake gesture.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { increasePage() }
    }
    
    /// This method passes current tip to destination if it is TipEditor and tipPassingAllowed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let controller = segue.destination as? TipEditor { tipPassingAllowed ? (controller.tip = tips.rank(of: page)) : (tipPassingAllowed = true) }
    }    
}
