//
//  NewTableViewCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell, SuggestionCell {

    // MARK: - Properties
    
    // MARK: - Properties: @IBOutlets

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var tipTextLabel: UILabel!
    
    @IBOutlet weak var indicatorImage: UIImageView!

    // MARK: - Properties: SuggetionCell
    
    var associatedTip: Tip? {
        didSet {
            categoryLabel.text = associatedTip?.category.formatted.string
            tipTextLabel.text  = associatedTip?.text.string
        }
    }

    var suggestion: SuggestedModeration = NewTip() {
        didSet { change(state: suggestion.state) }
    }
    
    // MARK: - Functions
    
    // MARK: - Functions: UITableViewCell

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
