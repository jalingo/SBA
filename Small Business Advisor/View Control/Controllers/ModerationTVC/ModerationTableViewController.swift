//
//  ModerationTableViewController.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit
import MagicCloud
import MessageUI

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = self.navigationController as? CentralNC { nav.decorateForModerationTVC() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        guard let suggestionNotificationNames = (self.navigationController as? CentralNC)?.allSuggestionNotifications else { return }
        
        for name in suggestionNotificationNames { observe(name: name) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nav = self.navigationController as? CentralNC { nav.isNavigationBarHidden = true }
    }
}

// MARK: - Extensions

// MARK: - Extensions: UITableViewDataSource

extension ModerationTableViewController {
    
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
            cell.associatedTip = tips[index]    // <-- must be done before suggestion. Create a multi dependency namespace
            cell.suggestion = suggestion
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let suggestion = suggestions[indexPath.row]

        switch suggestion {
        case is Flag: return actionsFor(mod: suggestion as! Flag)
        case is NewTip: return actionsFor(mod: suggestion as! NewTip)
        default:
            if let m = suggestion as? TipEdit { return actionsFor(mod: m) }
        }
        
        return nil
    }
    
    // !!
    fileprivate func actionsFor<T: MCRecordable>(mod: T) -> [UITableViewRowAction] {
        let cancel = UITableViewRowAction(style: .destructive, title: "Cancel") { _,_ in
            self.remove(mod)
            self.tableView.reloadData()
            
            guard let nav = self.navigationController as? CentralNC,
                let name = nav.allSuggestionNotifications.first else { return }
            NotificationCenter.default.post(name: name, object: nil)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Contact") { _,_ in
            var str: String?
            
            switch mod {
            case is Flag:   str = "Flag: \(String(describing: (mod as? Flag)?.reason.toStr()))"
            case is NewTip: str = "NewTip: \(String(describing: (mod as? NewTip)?.tip.recordID.recordName))"
            default:        str = "Edit: \(String(describing: (mod as? TipEdit)?.tip.recordID.recordName))"
            }
            
            if let str = str { self.switchToUsersMailApp(subject: str) }
        }
        
        return [cancel, edit]
    }
    
    // !!
    fileprivate func remove<T: MCRecordable>(_ mod: T) {
        guard let nav = self.navigationController as? CentralNC else { return }

        var mirror: MCMirror<T>?
        switch mod {
        case is Flag:   if let m = nav.flags as? MCMirror<T> { mirror = m }
        case is NewTip: if let m = nav.newTips as? MCMirror<T> { mirror = m }
        default:        if let m = nav.edits as? MCMirror<T> { mirror = m }
        }
        
        let name = mod.recordID.recordName
        if let index = mirror?.cloudRecordables.index(where: { $0.recordID.recordName == name }) { mirror?.cloudRecordables.remove(at: index) }
    }
    
    // !!
    fileprivate func switchToUsersMailApp(subject: String) {
        let mc = MFMailComposeViewController()
        
        mc.setSubject(subject)
        mc.setToRecipients(["sba@escapechaos.com"]) // <-- !!
        
        self.present(mc, animated: true, completion: nil)
    }
}
