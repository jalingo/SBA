//
//  TipCyclerTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 12/11/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud

class TipCyclerTests: XCTestCase {
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Functions: Unit Tests
    
    func testUploadAll() {
        VersionOneRestorer.loadOriginalTipsIntoCloudDatabase()
    }
}

protocol TipCycler {
    
}


class VersionOneRestorer {
    
    static var receiver: MCAnyReceiver<Tip> { return MCAnyReceiver<Tip>(db: .publicDB) }
    
    static func loadOriginalTipsIntoCloudDatabase() {
        var allVersionOneAdvice = [Tip]()
        for index in 1...TipFactory.max {
            if let advice = TipFactory.produceByIndex(index: index) as? Tip { allVersionOneAdvice.append(advice) }
        }
print("## Count: \(allVersionOneAdvice.count)")
        let op = MCUpload(allVersionOneAdvice, from: receiver, to: .publicDB)
        op.completionBlock = { print("## Finished") }
        OperationQueue().addOperation(op)
        
        op.waitUntilFinished()
    }
}
