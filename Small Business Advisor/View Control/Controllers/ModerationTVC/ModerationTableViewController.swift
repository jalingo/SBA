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
    
    // !!
    fileprivate func observe(name: Notification.Name) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    // MARK: - Functions: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nav = self.navigationController as? CentralNC { nav.decorateForModerationTVC() }
        
        self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        guard let suggestionNotificationNames = (self.navigationController as? CentralNC)?.allSuggestionNotifications else { return }
        
        for name in suggestionNotificationNames { observe(name: name) }
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
        }
    
        return cell
    }
}
