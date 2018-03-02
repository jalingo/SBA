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
    
    let _tips = MCMirror<Tip>(db: .publicDB)
    
    var tips: [Tip] { return _tips.cloudRecordables }

    let _votes = MCMirror<Vote>(db: .publicDB)

    var votes: [Vote] { return _votes.cloudRecordables }
    
    let _flags = MCMirror<Flag>(db: .publicDB)
    
    var flags: [Flag] { return _flags.cloudRecordables }
    
    let _edits = MCMirror<TipEdit>(db: .publicDB)
    
    var edits: [TipEdit] { return _edits.cloudRecordables }
    
    let _newTips = MCMirror<NewTip>(db: .publicDB)
    
    var newTips: [NewTip] { return _newTips.cloudRecordables }
    
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
