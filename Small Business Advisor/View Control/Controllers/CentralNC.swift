//
//  CentralNC.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud

// !!
class CentralNC: UINavigationController {

    // MARK: - Properties

    let tips = TipFactory()
    
    let votes = MCMirror<Vote>(db: .publicDB)
    
    let flags = MCMirror<Flag>(db: .publicDB)
    
    let edits = MCMirror<TipEdit>(db: .publicDB)
    
    let newTips = MCMirror<NewTip>(db: .publicDB)
    
    // MARK: - Functions
    
    func decorateForModerationTVC() {
        self.isNavigationBarHidden = false
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Tall_Header_Green"), for: .defaultPrompt)
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true   // This applies in all VCs except ModerationTVC
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CentralNC: UINavigationBarDelegate {
    
}
