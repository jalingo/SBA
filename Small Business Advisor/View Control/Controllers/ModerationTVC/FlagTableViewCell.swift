//
//  FlagTableViewCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

class FlagTableViewCell: UITableViewCell, SuggestionCell {

    // MARK: - Properties

    // MARK: - Properties: Suggestion
    
    var suggestion: SuggestedModeration = Flag()
    
    var associatedTip: Tip? {
        didSet {
            tipTextLabel.text = associatedTip?.text.string
            reasonLabel.text = (suggestion as? Flag)?.reason.toStr()
        }
    }
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var tipTextLabel: UILabel!
    
    // MARK: - Functions

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
