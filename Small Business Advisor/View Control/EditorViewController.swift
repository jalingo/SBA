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

// MARK: - Class: EditorViewController

class EditorViewController: UIViewController {

    // MARK: - Properties
    
    var currentTip: Tip?
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var upVoteButton: UIButton!
    
    @IBOutlet weak var downVoteButton: UIButton!
    
    @IBOutlet weak var addTipButton: UIButton!
    
    @IBOutlet weak var editTipButton: UIButton!
    
    @IBOutlet weak var flagTipButton: UIButton!
    
    // MARK: - Functions
    
    // MARK: - Functions: IBActions
    
    @IBAction func upVoteTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func downVoteTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func flagTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Determine button states...
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Disable all buttons...
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Functions: Constuction
    
    deinit {
        print("** EditorViewController deinitializing...")
    }
}

// MARK: - Extensions

//extension EditorViewController: MCReceiver {
//    typealias type =
//}

