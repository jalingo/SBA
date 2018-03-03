//
//  ModerationTableViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud

struct CellLabels {

    // !!
    
    static let new  = "Add_Cell"
    static let flag = "Flag_Cell"
    static let edit = "Edit_Cell"
    static let err  = "Err_Cell"
}

class ModerationTableViewController: UITableViewController {

    // MARK: - Properties
    
    let currentUser = MCUserRecord().singleton
    
    var suggestions: [SuggestedModeration] {
        if let nav = self.navigationController as? CentralNC { return nav.allSuggestions }
        return []
    }
    
    var tips: [Tip] {
        if let nav = self.navigationController as? CentralNC { return nav.tips.cloudRecordables }
        return []
    }
    
    // MARK: - Functions
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nav = self.navigationController as? CentralNC { nav.decorateForModerationTVC() }
        
        self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let nav = self.navigationController as? CentralNC {
            DispatchQueue.main.async { nav.isNavigationBarHidden = true }
        }
        
        super.viewWillDisappear(animated)
    }
}

// MARK: - Extensions

// MARK: - Extensions: UITableViewDataSource

extension ModerationTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return suggestions.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let suggestion = suggestions[indexPath.row]
        
        let identifier: String
        
        switch suggestion {
        case is NewTip:  identifier = CellLabels.new
        case is Flag:    identifier = CellLabels.flag
        case is TipEdit: identifier = CellLabels.edit
        default:         identifier = CellLabels.err
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? SuggestionCell,
            let index = tips.index(where: { $0.recordID.recordName == suggestion.tip.recordID.recordName }) {
            cell.associatedTip = tips[index]
            cell.suggestion = suggestion
            
            if let nav = self.navigationController as? CentralNC {
                switch suggestion {
                case is NewTip: observe(name: nav.newTips.changeNotification, on: nav.newTips, for: cell, with: suggestion as! NewTip)
                case is TipEdit: observe(name: nav.edits.changeNotification, on: nav.edits, for: cell, with: suggestion as! TipEdit)
                default: observe(name: nav.flags.changeNotification, on: nav.flags, for: cell, with: suggestion as! Flag)
                }
            }
        }
    
        return cell
    }
    
    fileprivate func observe<T>(name: Notification.Name, on mirror: MCMirror<T>, for cell: SuggestionCell, with suggestion: T) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { _ in
            if let index = mirror.cloudRecordables.index(where: { $0.recordID.recordName == suggestion.recordID.recordName }) {
                if let mod = mirror.cloudRecordables[index] as? SuggestedModeration { cell.suggestion = mod }
            }
        }
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
}
