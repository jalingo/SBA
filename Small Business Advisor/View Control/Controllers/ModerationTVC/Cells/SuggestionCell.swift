//
//  SuggestionCell.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/2/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import MagicCloud

/// This protocol is conformed to by `UITableViewCell`s presenting `SuggestedModeration` types.
protocol SuggestionCell: AnyObject {
    
    /// This property stores `SuggestedModeration` whose data will be displayed in view. When set, will update `reasonLabel` and `indicatorImage`
    var suggestion: SuggestedModeration { get set }

    /// This optional property stores any `Tip` associated with the `suggestion` property. When set, will update `tipTextLabel`
    var associatedTip: Tip? { get set }
    
    /// This IBOutlet property references cell's image indicating suggestion type. BG Color is changed to match state with the `change:state` method.
    weak var indicatorImage: UIImageView! { get set }
}

extension SuggestionCell {
    
    /// This internal, void method adjusts the BG Color of `indicatorImage` based on state.
    /// - Parameter state: The state BG Color of `indicatorImage` should match.
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
