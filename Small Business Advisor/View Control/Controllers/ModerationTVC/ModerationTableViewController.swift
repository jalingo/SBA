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

protocol SuggestionCell: AnyObject {
    var suggestion: SuggestedModeration { get set }
}

class ModerationTableViewController: UITableViewController {

    // MARK: - Properties
    
    let currentUser = MCUserRecord().singleton
    
    var suggestions: [SuggestedModeration] {
        if let nav = self.navigationController as? CentralNC {
            var array: [SuggestedModeration] = nav.flags.cloudRecordables
            array += nav.edits.cloudRecordables as [SuggestedModeration] + nav.newTips.cloudRecordables as [SuggestedModeration]
            
            return array
        }
        
        return []
    }
    
    // MARK: - Functions
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nav = self.navigationController as? CentralNC { nav.decorateForModerationTVC() }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        if let cell = cell as? SuggestionCell { cell.suggestion = suggestion }
        
        return cell
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
