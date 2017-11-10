//
//  ScoreCounterTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/9/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import CloudKit

class ScoreCounterTests: XCTestCase {
    
    // MARK: - Properties
    
    let testIndex = 1
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTest
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        
        // This gives time between tests, for all database requests from previous interactions to be served.
        let group = DispatchGroup()
        group.enter()
        
        let pause = Pause(seconds: 5)
        pause.completionBlock = { group.leave() }
        OperationQueue().addOperation(pause)
        
        group.wait()
        super.tearDown()
    }

    // MARK: - Functions: Tests
    
    func testScoreCounterCanProduceScore() {
        XCTAssertNotNil(ScoreCounter.score(for: testIndex))
    }
}

struct ScoreCounter {
    
    static let database = CKContainer.default().publicCloudDatabase
    
    static func decorate(for index: Int) -> CKQueryOperation {
        let predicate = NSPredicate(format: "\(RecordKey.indx) = \(index)")
        let query = CKQuery(recordType: RecordType.entry, predicate: predicate)
        let op = CKQueryOperation(query: query)

        op.queryCompletionBlock = { possibleCursor, possibleError in
            
        }
        
        return op
    }
    
    static func score(for index: Int) -> NSNumber {
        let op = decorate(for: index)
        
        let group = DispatchGroup()
        group.enter()

        op.recordFetchedBlock = { record in
            
        }
        
        database.add(op)
        group.wait()
        return NSNumber(value: 0)
    }
}
