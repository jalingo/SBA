//
//  MCDatabaseType.swift
//  MagicCloud
//
//  Created by Jimmy Lingo on 5/16/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import CloudKit

// MARK: - Enum

/// This enumerates the different cloud databases available as strings, and provides access
public enum MCDatabase: String {
    
    /// A string enumeration of CKContainer.default().publicCloudDatabase
    case publicDB
    
    /// A string enumeration of CKContainer.default().privateCloudDatabase
    case privateDB
    
    /// A string enumeration of CKContainer.default().sharedCloudDatabase
    case sharedDB

    /// Derives and returns an MCDatabaseType from a CKDatabaseScope.
    static func from(scope: CKDatabaseScope) -> MCDatabase {
        switch scope {
        case .private:  return .privateDB
        case .public:   return .publicDB
        case .shared:   return .sharedDB
        }
    }
    
    /// This read-only, computed property returns the actual CKDatabase being enumerated.
    var db: CKDatabase {
        switch self {
        case .publicDB: return CKContainer.default().publicCloudDatabase
        case .privateDB: return CKContainer.default().privateCloudDatabase
        case .sharedDB: return CKContainer.default().sharedCloudDatabase
        }
    }
}
