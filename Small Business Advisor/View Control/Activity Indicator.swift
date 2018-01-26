//
//  Activity Indicator.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 1/25/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

protocol ActivitySpinner: AnyObject {
    var indicator: UIActivityIndicatorView { get set }
    
    func startWaiting()
    
    func stopWaiting()
}

extension ActivitySpinner where Self: UIViewController {
    
    func startWaiting() {
        self.view.alpha = 0.7
        
        indicator.color = Format.ecGreen
        indicator.hidesWhenStopped = true
        indicator.alpha = 1.0
        
        self.view.addSubview(indicator)
    }
    
    func stopWaiting() {
        self.view.alpha = 1.0
        indicator.removeFromSuperview()
    }
}
