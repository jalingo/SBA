//
//  AdvisorViewController.swift
//  Small Business Advisor
//
//  Created by James Lingo on 9/3/17.
//  Copyright © 2017 James Lingo. All rights reserved.
//

import UIKit

class AdvisorViewController: UIViewController {
    
    // MARK: - Properties
    
    var response = ResponseText()
    
    var page = 0 {
        didSet { pageLabel.text = String(page) }
    }
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var randomSwitch: UISwitch!
    
    // MARK: - Properties: UIResponder
    
    @objc override var canBecomeFirstResponder: Bool {
        get { return true }
    }
    
    // MARK: - Functions
    
    fileprivate func shakeRoutine() {
        if randomSwitch.isOn {
            let random = response.byRandom()
            
            textView.attributedText = random
            pageLabel.text = "\(response.lastIndex)"
        } else {
            page < TipFactory.max ? (page += 1) : (page = 0)
            textView.attributedText = response.byIndex(of: page)
        }
    }
    
    fileprivate func decreasePage() {
        
        // If in "Random Mode", a swipe is treated as a shake.
        guard !randomSwitch.isOn else { shakeRoutine(); return }
        
        // Else, a swipe right means go back.
        page < 1 ? (page -= 1) : (page = TipFactory.max)   
        textView.attributedText = response.byIndex(of: page)
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func randomSwitched(_ sender: UISwitch) {
        if sender.isOn {
            textView.text = "Shake for Advice!"
        } else {
            textView.text = "Swipe through the various tips..."
        }
    }
    
    @IBAction func helpPressed(_ sender: UIButton) {
        textView.text = "To contact the app's creators with any questions or comments, email dev@escapechaos.com.\n\nOr, check out our site escapechaos.com"
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) { shakeRoutine() }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) { decreasePage() }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { shakeRoutine() }
    }
}
