//
//  FlagTableViewCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/1/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

/// This sub-class of `UITableViewCell` presents a GUI interpretation of data model's `Flag` type.
class FlagTableViewCell: UITableViewCell, SuggestionCell {    

    // MARK: - Properties

    // MARK: - Properties: Suggestion
    
    /// This property stores `SuggestedModeration` whose data will be displayed in view. When set, will update `reasonLabel` and `indicatorImage`
    var suggestion: SuggestedModeration = Flag() {
        didSet {
            change(state: suggestion.state)
            reasonLabel.text = (suggestion as? Flag)?.reason.toStr()
        }
    }
    
    /// This optional property stores any `Tip` associated with the `suggestion` property. When set, will update `tipTextLabel`
    var associatedTip: Tip? {
        didSet { tipTextLabel.text = associatedTip?.text.string }
    }
    
    // MARK: - Properties: IBOutlets
    
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var tipTextLabel: UILabel!
    
    @IBOutlet weak var indicatorImage: UIImageView!
}
