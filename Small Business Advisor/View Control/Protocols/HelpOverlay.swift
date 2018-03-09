//
//  HelpOverlay.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 3/8/18.
//  Copyright © 2018 Escape Chaos. All rights reserved.
//

import UIKit

let helpOverlayId = "Help_Overlay"

let HelperViewTapped = Notification.Name(helpOverlayId)

protocol HelpOverlayer { }

extension HelpOverlayer where Self: UIViewController {
    func presentHelpOverlay() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: helpOverlayId) as? HelpOverlayViewController else { return }
        UIApplication.shared.keyWindow?.addSubview(vc.view)
    }
}
