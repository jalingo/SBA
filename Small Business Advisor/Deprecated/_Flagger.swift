//
//  Flagger.swift
//  Small Biz Advisor
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import MagicCloud
import CloudKit

// !!
protocol FlaggerAbstraction {
    func flags(for id: CKRecordID) -> [Flag]?
    
    func post(_ flag: Flag)
}

class _Flagger: MCReceiver<Flag>, FlaggerAbstraction {
    func flags(for id: CKRecordID) -> [Flag]? {
        return recordables.filter { $0.recordID.recordName == id.recordName }
    }
    
    func post(_ flag: Flag) {
        let op = MCUpload([flag], from: self, to: .publicDB)
        OperationQueue().addOperation(op)
    }
}
