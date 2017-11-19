////
////  TipReceiver.swift
////  Small Biz Advisor
////
////  Created by James Lingo on 11/16/17.
////  Copyright © 2017 Escape Chaos. All rights reserved.
////
//
//import Foundation
//import MagicCloud
//import CloudKit
//
//class TipReceiver: ReceivesRecordable {
//    typealias type = Tip
//    
//    var recordables = [type]() /*{
//        didSet {
//            print("** TipReceiver didSet: \(recordables.count)")
//            
//            guard allowRecordablesDidSetToUploadDataModel else { return }
//            
//            let op = Upload(from: self, to: .publicDB)
//            OperationQueue().addOperation(op)
//            
//            // This resets trigger safety
//            allowRecordablesDidSetToUploadDataModel = false
//        }
//    }*/
//
//    
//    func startListening() {
//        setupListener(for: RecordType.entry, change: .firesOnRecordCreation) { }
//        setupListener(for: RecordType.entry, change: .firesOnRecordDeletion)
//        setupListener(for: RecordType.entry, change: .firesOnRecordUpdate)
//    }
//    
//    func stopListening() { }
//    
//    func refresh(completion: OptionalClosure = nil) {
//        recordables = []    // <- Clears out current recordables for batch download.
//        
//        let op = Download(type: RecordType.entry, to: self, from: .publicDB)
//        op.completionBlock = completion
//        OperationQueue().addOperation(op)
//    }
//    
//    init() {
//        refresh()
//        startListening()
//    }
//    
//    deinit { stopListening() }
//}

