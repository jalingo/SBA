//
//  CategoryFactoryTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/27/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class TipCategoryFactoryTests: XCTestCase {
    
    // MARK: - Properties
    
//    var mock: CategoryFactory?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
//        mock = MockTipCategoryFactory()
        
    }
    
    override func tearDown() {
//        mock = nil
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testTipCategoryFactoryProducesByIndex() {
        XCTAssertNotNil(MockTipCategoryFactory.produceByIndex(index: 0))
    }
    
    func testTipCategoryOnlyAcceptsRecognizesOutOfRange() {
        XCTAssert(MockTipFactory.produceByIndex(index: MockTextFactory.max + 1).category == TipCategory.outOfRange)      // <- This needs to switch from the mock to the standard
    }
    
    func testPlanningMatchesRange() {
        let range = TipCategory.planning.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .planning) }
    }
    
    func testOrganizationMatchesRange() {
        let range = TipCategory.organization.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .organization) }
    }
    
    func testMarketingMatchesRange() {
        let range = TipCategory.marketing.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .marketing) }
    }
    
    func testOperationsMatchesRange() {
        let range = TipCategory.operations.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .operations) }
    }
    
    func testTechnologyMatchesRange() {
        let range = TipCategory.technology.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .technology) }
    }
    
    func testValueMatchesRange() {
        let range = TipCategory.value.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .value) }
    }
    
    func testEfficiencyMatchesRange() {
        let range = TipCategory.efficiency.indexRange
        
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .efficiency) }
    }
    
    func testFiscalMatchesRange() {
        let range = TipCategory.fiscal.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .fiscal) }
    }
    
    func testHrMatchesRange() {
        let range = TipCategory.hr.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .hr) }
    }
    
    func testSecurityMatchesRange() {
        let range = TipCategory.security.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .security) }
    }
    
    func testLegalMatchesRange() {
        let range = TipCategory.legal.indexRange
        for index in range { XCTAssert(MockTipCategoryFactory.produceByIndex(index: index) == .legal) }
    }
}

struct MockTipCategoryFactory: CategoryFactory {
    static func produceByIndex(index: Int) -> TipCategory {
        
        switch index {
        case TipCategory.planning.indexRange:       return .planning
        case TipCategory.organization.indexRange:   return .organization
        case TipCategory.marketing.indexRange:      return .marketing
        case TipCategory.operations.indexRange:     return .operations
        case TipCategory.technology.indexRange:     return .technology
        case TipCategory.value.indexRange:          return .value
        case TipCategory.efficiency.indexRange:     return .efficiency
        case TipCategory.fiscal.indexRange:         return .fiscal
        case TipCategory.hr.indexRange:             return .hr
        case TipCategory.security.indexRange:       return .security
        case TipCategory.legal.indexRange:          return .legal
        default:                                    return .outOfRange
        }
    }
}
