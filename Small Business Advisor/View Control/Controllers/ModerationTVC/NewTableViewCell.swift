//
//  NewTableViewCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    // MARK: - Properties: @IBOutlets

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var tipTextLabel: UILabel!
    
    // MARK: - Properties: SuggetionCell
    
    var _suggestion: SuggestedModeration?
    
    // MARK: - Functions
    
    // MARK: - Functions: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if let txt = _suggestion?.
//        categoryLabel.attributedText =
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NewTableViewCell: SuggestionCell {
    var suggestion: SuggestedModeration {
        get { return _suggestion ?? NewTip() }
        set { _suggestion = newValue }
    }
}
