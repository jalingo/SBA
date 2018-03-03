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
    weak var indicatorImage: UIImageView! { get set }
}

extension SuggestionCell {
    func change(state: ModerationState) {
        DispatchQueue.main.async {
            switch state {
            case .submitted:      self.indicatorImage?.backgroundColor = Colors.ecRed
            case .opened:         self.indicatorImage?.backgroundColor = .orange
            case .closedApproved: self.indicatorImage?.backgroundColor = Colors.ecGreen
            case .closedRejected: self.indicatorImage?.backgroundColor = .gray
            }
        }
    }
}
