//
//  CurrentTipTests.swift
//  Small Biz AdvisorTests
//
//  Created by James Lingo on 11/9/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest
import MagicCloud

class CurrentTipTests: XCTestCase {
    
    // MARK: - Properties

    let testIndex = 1

    var mock: CurrentTip?
    
    // MARK: - Functions
    
    // MARK: - Functions: XCTestCase
    
    override func setUp() {
        super.setUp()
        mock = MockCurrentTip()
        mixedUpVotes = nil
    }
    
    override func tearDown() {
        mock = nil
        
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
    
    func testCurrentTipCanProvideCategory() {
        XCTAssertNotNil(mock?.category(for: testIndex))
        XCTAssertEqual(mock?.category(for: testIndex),
                       TipCategoryFactory.produceByIndex(index: testIndex).formatted)
    }
    
    func testCurrentTipCanProvideText() {
        XCTAssertNotNil(mock?.text(for: testIndex))
        XCTAssertEqual(mock?.text(for: testIndex), TextFactory.produce(for: testIndex))
    }
    
    func testCurrentTipCanProvideScore() {
        let _ = prepareDatabase()
        
        XCTAssertNotNil(mock?.score(for: testIndex))
        
        let score = NSNumber(value: 2)   // <-- This is pre-established in TestTools.swift/testRecords
        XCTAssertEqual(score, mock?.score(for: testIndex))
        
        let _ = cleanUpDatabase()
    }
    
    func testCurrentTipCanProvideRank() {
        let _ = prepareDatabase()
        
        XCTAssertNotNil(mock?.rank(for: testIndex))
        
        let firstPlace = testRecords[0]
        if let rank = firstPlace[RecordKey.rank] as? Int {
            XCTAssertEqual(rank, mock?.rank(for: testIndex))
        } else {
            XCTFail()
        }
        
        let _ = cleanUpDatabase()
    }
}

protocol CurrentTip {
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    func category(for index: Int) -> NSAttributedString
    
    func text(for index: Int) -> NSAttributedString
    
    func score(for index: Int) -> NSNumber
    
    func rank(for index: Int) -> Int
}

struct MockCurrentTip: CurrentTip {
    
    // MARK: - Properties
    
    var advice = [Tip]()
    
    // MARK: - Functions
    
    func category(for index: Int) -> NSAttributedString {
        return TipCategoryFactory.produceByIndex(index: index).formatted
    }
    
    func text(for index: Int) -> NSAttributedString {
        return TextFactory.produce(for: index)
    }

    func score(for index: Int) -> NSNumber {
        return NSNumber(value: 0)
    }
    
    func rank(for index: Int) -> Int {
        return 0
    }
}
