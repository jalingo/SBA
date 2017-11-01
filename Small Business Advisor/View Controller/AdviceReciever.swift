//
//  AdviceReciever.swift
//  Small Business Advisor
//
//  Created by James Lingo on 11/1/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation

/// This protocol ensures that conforming view controllers have requirements to work with data model.
protocol AdviceReciever: AnyObject {
    
    /// This serves the accessor for the data model. Needs to be a variable to allow mutation for index tracking.
    var response: ResponseText { get set }
    
    /// The current page of the view correlates to the index of current model entry.
    var page: Int { get set }
}
