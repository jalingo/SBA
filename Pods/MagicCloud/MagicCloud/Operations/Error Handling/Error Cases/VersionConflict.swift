//
//  VersionConflict.swift
//  slBackend
//
//  Created by Jimmy Lingo on 5/22/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import CloudKit

/// Deals with serverRecordChanged CKErrors based on specified policy.
class VersionConflict<R: MCMirrorAbstraction>: Operation {
    
    // MARK: - Properties

    /**
        This policy is used to determine how version conflict will be resolved. Defaults to .changedKeys.
     
        - .changedKeys (default): Ignores record tags and updates specific fields that have been changed.
        - .allKeys: Ignores record tags and overwrites all fields from newer record.
        - .ifServerUnchanged: Respects record tags and rejects all values from newer record.
     */
    var policy: CKRecordSavePolicy
    
    let receiver: R
    
    /**
        This is the CKError that has already been identified as a version conflict (guard statement
        will cause function to return nil if it is a different error type).
     */
    fileprivate var error: CKError?
    
    /// These are the recordables that threw CKError.serverRecordChanged.
    fileprivate var recordables = [R.type]()

    /// This is the database where version conflict was detected.
    fileprivate var database: MCDatabase
    
    /// This operation is launched after version conflict resolved.
    fileprivate var completionOperation = Operation()
    
    // MARK: - Functions
    
    /// This method determines approach to use (based on policy).
    fileprivate func conflictResolution() -> CKRecord? {
        guard error?.code == .serverRecordChanged else { return nil }

        switch policy {
        case .changedKeys:              return changedKeys()
        case .allKeys:                  return allKeys()
        case .ifServerRecordUnchanged:  return nil          // <-- Any resolution will be skipped.
        }
    }

    /**
     * This method is used during cloud error handling, to repair version conflicts (reported as
     * `ServerRecordChanged` CKError), under CKRecordSavePolicy.allKeys.
     */
    fileprivate func allKeys() -> CKRecord? {
        return error?.userInfo[CKRecordChangedErrorClientRecordKey] as? CKRecord
    }
    
    /**
     * This method is used during cloud error handling, to repair version conflicts (reported as
     * `ServerRecordChanged` CKError), under CKRecordSavePolicy.changedKeys.
     */
    fileprivate func changedKeys() -> CKRecord? {
        guard let original = error?.userInfo[CKRecordChangedErrorAncestorRecordKey] as? CKRecord,
            let current = error?.userInfo[CKRecordChangedErrorServerRecordKey] as? CKRecord,
            let attempt = error?.userInfo[CKRecordChangedErrorClientRecordKey] as? CKRecord
            else {
                print("recordableIsNil @ VersionConflict:0")
                return nil
        }
        
        var recordable: MCRecordable?
        for instance in recordables {
            if instance.recordID.recordName == current.recordID.recordName { recordable = instance }
        }

        guard recordable != nil else { print("recordableIsNil @ VersionConflict:1"); return nil }
        
        for entry in recordable!.recordFields {
            if let originalValue = original[entry.key],
                let currentValue = current[entry.key],
                let attemptValue = attempt[entry.key] {
                
                switch entry.value {
                case is NSNumber:
                    if currentValue as? NSNumber == originalValue as? NSNumber &&
                        currentValue as? NSNumber != attemptValue as? NSNumber {
                        current[entry.key] = attemptValue
                    }
                case is NSData:
                    if currentValue as? NSData == originalValue as? NSData &&
                        currentValue as? NSData != attemptValue as? NSData {
                        current[entry.key] = attemptValue
                    }
                case is NSDate:
                    if currentValue as? NSDate == originalValue as? NSDate &&
                        currentValue as? NSDate != attemptValue as? NSDate {
                        current[entry.key] = attemptValue
                    }
                case is CKAsset:
                    if currentValue as? CKAsset == originalValue as? CKAsset &&
                        currentValue as? CKAsset != attemptValue as? CKAsset {
                        current[entry.key] = attemptValue
                    }
                case is CLLocation:
                    if currentValue as? CLLocation == originalValue as? CLLocation &&
                        currentValue as? CLLocation != attemptValue as? CLLocation {
                        current[entry.key] = attemptValue
                    }
                case is CKReference:
                    if currentValue as? CKReference == originalValue as? CKReference &&
                        currentValue as? CKReference != attemptValue as? CKReference {
                        current[entry.key] = attemptValue
                    }
                default:    // <-- String
                    if currentValue as? String == originalValue as? String &&
                        currentValue as? String != attemptValue as? String {
                        current[entry.key] = attemptValue
                    }
                }
            }
        }
        
        return current
    }
    
    fileprivate func handle(_ error: Error?, from op: CKOperation) {
        
        if isCancelled { return }
        
        if let cloudError = error as? CKError {
            let errorHandler = MCErrorHandler(error: cloudError,
                                              originating: op,
                                              target: database,
                                              instances: recordables,
                                              receiver: receiver)
            
            self.completionOperation.addDependency(errorHandler)
            
            let q = OperationQueue()
            q.addOperation(self.completionOperation)
            q.addOperation(errorHandler)
        } else {
            print("Not CKError: \(String(describing: error)) @ VersionConflictOp")
        }
    }
    
    // MARK: - Functions: Operation
    
    override func main() {
        if isCancelled { return }
        
        if let record = conflictResolution() {

            // Uploads current record with changes made and latest changeTag.
            let op = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            op.modifyRecordsCompletionBlock = { records, recordIDs, error in
                guard error == nil else { self.handle(error, from: op); return }
            }
            
            if isCancelled { return }
                        
            // Tags completion block from original operation onto the end of the conflict resolution.
            if completionOperation.completionBlock != nil {
                completionOperation.addDependency(op)
                OperationQueue().addOperation(completionOperation)
            }
            
            database.db.add(op)
        }
    }
    
    // MARK: - Functions: Constructor
    
    init(rec: R, error: CKError, target: MCDatabase, policy: CKRecordSavePolicy, instances: [R.type], completionBlock: OptionalClosure) {
        receiver = rec
        
        self.error = error
        self.policy = policy
        
        recordables = instances
        completionOperation.completionBlock = completionBlock
        database = target

        super.init()
    }
}
