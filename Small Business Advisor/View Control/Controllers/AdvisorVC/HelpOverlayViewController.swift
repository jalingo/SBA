//
//  HelpOverlayViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/8/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud
import CloudKit

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

        // This notification is triggered when the USER taps the help view, causing it to dismiss.
        NotificationCenter.default.addObserver(forName: HelperViewTapped, object: nil, queue: nil) { _ in
            self.removeSelfFromView()
        }
        
        // !!!!
        
        // This notification observer removes help display on first launch when no icloud account is authenticated.
        let name = Notification.Name(MCErrorNotification)
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { notification in
            if let error = notification.object as? CKError, error.code == CKError.notAuthenticated { self.removeSelfFromView() }
        }
        
        if let v = self.view as? HelperView {
            let recognizer = UITapGestureRecognizer(target: self.view, action: #selector(v.exit))
            self.view.addGestureRecognizer(recognizer)
        }
    }
    
    // This fileprivate, void method dismisses the help view on the main thread.
    fileprivate func removeSelfFromView() {
        DispatchQueue.main.async { self.view.removeFromSuperview() }
    }
}

class HelperView: UIImageView {
    @objc func exit() { NotificationCenter.default.post(name: HelperViewTapped, object: nil) }
}
