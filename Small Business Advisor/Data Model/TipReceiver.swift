//
//  TipReceiver.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 11/16/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import Foundation
import MagicCloud

class TipReceiver: ReceivesRecordable {
    
    typealias type = Tip
    
    /**
        This protected property is an array of Tips used by reciever.
     */
    var recordables = [type]() {
        didSet { print("** TipReceiver didSet: \(recordables.count)") }
    }
    
    /**
        This boolean property allows / prevents changes to `recordables` being stored in
        the cloud.
     */
    var allowRecordablesDidSetToUploadDataModel: Bool = false

}
