//
//  SuggestionCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/2/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import MagicCloud

protocol SuggestionCell: AnyObject {
    var suggestion: SuggestedModeration { get set }
    var associatedTip: Tip? { get set }
    var indicatorImage: UIImageView { get set }
}


extension SuggestionCell {
    func change(state: ModerationState) {
        switch state {
        case .submitted:      indicatorImage.backgroundColor = .gray
        case .opened:         indicatorImage.backgroundColor = .yellow
        case .closedApproved: indicatorImage.backgroundColor = Format.ecGreen
        case .closedRejected: indicatorImage.backgroundColor = UIColor(displayP3Red: 255.0,
                                                                       green: 38.0,
                                                                       blue: 0.0,
                                                                       alpha: 1.0)
        }
    }
}
