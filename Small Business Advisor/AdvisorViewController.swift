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
            pageLabel.text = ""
            textView.text = Response.random()
        } else {
            page += 1
            textView.text = Response.regular(for: page)
        }
    }
    
    // MARK: - Functions: IBActions
    
    @IBAction func helpPressed(_ sender: UIButton) {
        textView.text = "To contact the app's creator with any questions or comments, email james@escapechaos.com."
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { shakeRoutine() }
    }
}

// MARK: - Struct: Response

struct Response {
    
    // Stores the various responses, and delivers them randomly.
    static func random() -> String { return Entry.response(for: .random) }
    
    static func regular(for page: Int) -> String { return "Regular Response" }
}
