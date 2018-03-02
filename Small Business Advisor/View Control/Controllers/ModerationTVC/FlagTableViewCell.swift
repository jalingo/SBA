//
//  FlagTableViewCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

class FlagTableViewCell: UITableViewCell {

    // MARK: - Properties

    // MARK: - Properties: Suggestion
    
    var _suggestion: SuggestedModeration?
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FlagTableViewCell: SuggestionCell {
    var suggestion: SuggestedModeration {
        get { return _suggestion ?? NewTip() }
        set { _suggestion = newValue }
    }
}
