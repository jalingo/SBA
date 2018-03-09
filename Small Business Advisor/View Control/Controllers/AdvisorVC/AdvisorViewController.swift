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
class AdvisorViewController: UIViewController, PickerDecorator, HelpOverlayer, FirstTryDetector {
    
    // MARK: - Properties
    
    /// This receiver is the primary connection to the data model. Handles vote counting locally.
    /// Access an array of all existing types in .recordables
    var tips: TipFactory? {
        guard let nav = self.navigationController as? CentralNC else { return nil }
        return nav.tips
    }
    
    /// This boolean can be used to prevent AdvisorVC from passing tip to TipEditor in AdvisorVC.prepare:forSegue:
    var tipPassingAllowed = true
    
    /// `page` stores index of the current entry from the data model, and when set `pageLabel.text` is refreshed.
    var page = 0 {
        didSet {
            categoryLock.isEnabled = true
            pageLabel.text = String(page)

            if tips?.cloudRecordables.count != 0 { passTipToChildren() }
            
            if let txt = tips?.rank(of: page).category.formatted { selectCategoryButton.setAttributedTitle(txt, for: .normal) }
        }
    }
    
    /// `isRandom` is toggled between `true` (next entry determined at random) & `false` (entries come in order).
    var isRandom = true {
        didSet { adjustChangeType(when: isRandom) }
    }
    
    /// This fileprivate, void method changes ranked / random indicators.
    /// - Parameter random: If true, indicators will highlight random. Else, indicators will highlight ranked.
    fileprivate func adjustChangeType(when random: Bool) {
        randomBar.isHidden = !random
        rankedBar.isHidden = random
        
        randomSwitched()
    }
    
    // MARK: - - Properties: IBOutlets
    
    /// This IBOutlet property serves as change type indicator. When visible, change order is random.
    @IBOutlet weak var randomBar: UIImageView!
    
    /// This IBOutlet property serves as change type indicator. When visible, change order is according to rank.
    @IBOutlet weak var rankedBar: UIImageView!
    
    /// `pageLabel` shows the rank of the current entry from the data model.
    @IBOutlet weak var pageLabel: UILabel!
    
    /// `textView` shows the body text from the current entry from the data model.
    @IBOutlet weak var textView: UITextView!

    /// This IBOutlet property displays current tip's category and serves a button to limit list by category.
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    /// This IBOutlet property displays category lock status and switchs category limitation state.
    @IBOutlet weak var categoryLock: UIButton!
    
    /// This IBOutlet property dipslays a link to the `ModerationTableViewController` if USER has any suggestions.
    @IBOutlet weak var suggestionsButton: UIButton!
    
    // MARK: - - Properties: UIResponder
    
    /// This override allows `AdvisorViewController` to become first responder (to user interactions); always true.
    @objc override var canBecomeFirstResponder: Bool { return true }
    
    // MARK: - Functions
    
    /// When `randomSwitch` tapped, this populates screen with instructions, based on switch outcome.
    fileprivate func randomSwitched() {
        let txt: String
        isRandom ? (txt = UserFacingText.shakeInstructions) : (txt = UserFacingText.swipeInstructions)
        
        textView.attributedText = NSAttributedString(string: txt, attributes: Format.categoryTitle)
    }
    
    /// This fileprivate, void method adds observers that will check for `suggestionsButton` visibility for `allSuggestionsNotifications`
    fileprivate func listenForModerationUpdate() {
        guard let nav = self.navigationController as? CentralNC else { return }
        
        for name in nav.allSuggestionNotifications {
            NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { _ in
                if nav.userHasSuggestions {
                    DispatchQueue.main.async { self.suggestionsButton.isHidden = !nav.userHasSuggestions }
                }
            }
        }
    }
    
    // This fileprivate, void method decorates the view for USER presentation.
    fileprivate func decorateView() {
        if let nav = self.navigationController as? CentralNC { suggestionsButton.isHidden = !nav.userHasSuggestions }
        setBackgroundImg()
        textView.attributedText = NSAttributedString(string: UserFacingText.shakeInstructions,
                                                     attributes: Format.categoryTitle)
    }
    
    // This fileprivate, void method sets background image for main view.
    fileprivate func setBackgroundImg() {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "Main BG"))
        imgView.frame = self.view.frame
        
        self.view.addSubview(imgView)
        self.view.sendSubview(toBack: imgView)
    }
    
    /// This method presents a pickerView representing categories when USER specifies category limitation.
    fileprivate func pick() {
        let picker = UIPickerView()
        decorate(picker, for: self)
        
        view.addSubview(picker)
    }
    
    /// This method will pass current tip to any child view controllers conforming to TipEditor (see above).
    fileprivate func passTipToChildren() {
        for child in childViewControllers {
            if let controller = child as? TipEditor { tipPassingAllowed ? (controller.tip = tips?.rank(of: page)) : (tipPassingAllowed = true) }
        }
    }
    
    /**
        `increasePage` should be run whenever the USER performs shake gesture or swipes to move forward (swiping backwards call `decreasePage` instead).
     
        Recognizes `increasePage` position, and ensures that page number doesn't exceed count (starting over again at page '1').
     */
    func increasePage() {
        guard let tips = tips else { return }

        if isRandom {
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
        guard let tips = tips else { return }

        // If in "Random Mode", a swipe is treated as a shake.
        guard !isRandom else { increasePage(); return }
        
        // Else, a swipe right means go back.
        page > 1 ? (page -= 1) : (page = tips.count)
        textView.attributedText = tips.rank(of: page).text
    }
    
    // MARK: - - Functions: IBActions
    
    /// This IBAction method is used by other view controllers to unwind back to AdvisorViewController.
    @IBAction func unwindToHome(segue: UIStoryboardSegue) { }
    
    /// This IBAction method exits the app and opens browser (w/specified site) when user taps logo.
    @IBAction func logoTapped(_ sender: UIButton) {
        if let url = URL(string: URL_str.homePage) { UIApplication.shared.open(url) }
    }

    @IBAction func randomPressed(_ sender: UIButton) { isRandom = true }

    @IBAction func rankedPressed(_ sender: UIButton) { isRandom = false }
    
    /**
        When `helpPressed` this method populates screen with help message overlay.
     */
    @IBAction func helpPressed(_ sender: UIButton) { presentHelpOverlay() }
    
    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) { increasePage() }

    /// Recognizes the USER performing swipe gesture on `textView` and takes action based on direction.
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) { decreasePage() }
    
    /// This IBAction method switches category limitation lock state when user taps category lock button.
    @IBAction func categoryLockTapped(_ sender: UIButton) {
        guard let tips = tips else { return }

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

        listenForModerationUpdate()
        self.becomeFirstResponder()
        
        if isFirsRunEver { presentHelpOverlay() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        decorateView()
    }
    
    // This method triggers `shakeRoutine` after USER performs shake gesture.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { increasePage() }
    }
    
    // This method passes current tip to destination if it is TipEditor and tipPassingAllowed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let controller = segue.destination as? TipEditor { tipPassingAllowed ? (controller.tip = tips?.rank(of: page)) : (tipPassingAllowed = true) }
    }    
}
