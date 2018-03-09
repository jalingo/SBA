//
//  HelpOverlayViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/8/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

class HelpOverlayViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    
    // MARK: - Properties: IBOutlets

    @IBOutlet weak var textArea: UITextView!
    
    // MARK: - Functions

    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.attributedText = NSAttributedString(string: UserFacingText.helpInstructions,
                                                     attributes: Format.categoryTitle)
        setupGestureDismissal()
    }
    
    func setupGestureDismissal() {
        textArea.delegate = self
        textArea.keyboardDismissMode = .onDrag
        
        NotificationCenter.default.addObserver(forName: HelperViewTapped, object: nil, queue: nil) { _ in
            self.view.removeFromSuperview()
        }
        
        if let v = self.view as? HelperView {
            let recognizer = UITapGestureRecognizer(target: self.view, action: #selector(v.exit))
            self.view.addGestureRecognizer(recognizer)
        }
    }
}

class HelperView: UIImageView {
    @objc func exit() { NotificationCenter.default.post(name: HelperViewTapped, object: nil) }
}
