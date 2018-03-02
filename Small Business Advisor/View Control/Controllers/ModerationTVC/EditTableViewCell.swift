//
//  EditTableViewCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell, SuggestionCell {

    // MARK: - Properties
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var tipTextLabel: UILabel!
    
    // MARK: - Properties: SuggestionCell
    
    var associatedTip: Tip? {
        didSet {
            categoryLabel.text = associatedTip?.category.formatted.string
            tipTextLabel.text  = associatedTip?.text.string
        }
    }
    
    var suggestion: SuggestedModeration = TipEdit()
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
