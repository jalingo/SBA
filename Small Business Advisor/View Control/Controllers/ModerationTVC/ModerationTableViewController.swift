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

// MARK: Class

/// This sub-class of `UITableViewController` has a single column and lists rows of cells representing the various `SuggestedModeration`s created by current USER. Cells can be used to access data, contact support or cancel moderation.
class ModerationTableViewController: UITableViewController {

    // MARK: - Properties
    
    /// This constant optional property stores current USER recordID, or if cloud issues: nil.
    fileprivate let currentUser = MCUserRecord().singleton

    /// This read-only, computed property returns an array of all `SuggestedModeration`s stored in database.
    fileprivate var suggestions: [SuggestedModeration] {
        if let nav = self.navigationController as? CentralNC { return nav.allSuggestions }
        return []
    }
    
    /// This read-only, computed property returns an array of `Tip`s stored in database.
    fileprivate var tips: [Tip] {
        if let nav = self.navigationController as? CentralNC { return nav.tips.cloudRecordables }
        return []
    }
    
    // MARK: - Functions
    
    /// This fileprivate, void method adds an observer to the default notification center for name passed. When heard, observer will reload tableView data.
    /// - Parameter name: This argument passes the notification name that will be listened for by observer.
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
    
    // MARK: - Functions
    
    /// This fileprivate method returns an array of `UITableViewRowAction`s for cells associated with the passed `MCRecordable`.
    /// - Parameter mod: An `MCRecordable` effected by returned actions.
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
            
            if let str = str { self.writeEmail(subject: str) }
        }
        
        return [cancel, edit]
    }
    
    /// This fileprivate, void method destroys both local (and eventually cloud) records of passed `MCRecordable`.
    /// - Parameter mod: An `MCRecordable` removed from local cache and database.
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
    
    // MARK: - Functions: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return suggestions.count }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: false) }

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
}


extension ModerationTableViewController: MFMailComposeViewControllerDelegate {
    
    // MARK: - Functions
  
    /// This fileprivate, void method presents a `MFMailComposeViewController` with the passed subject preloaded.
    /// - Parameter subject: This argument will be set as the default subject of USER's email.
    fileprivate func writeEmail(subject: String) {
        let mc = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(subject)
        mc.setToRecipients([EmailAddress.sba])
        
        guard MFMailComposeViewController.canSendMail() else { return }
        self.present(mc, animated: true, completion: nil)
    }
    
    // MARK: - Functions: MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
