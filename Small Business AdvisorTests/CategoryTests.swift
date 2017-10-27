//
//  CategoryTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/25/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class CategoryTests: XCTestCase {
    
    // MARK: - Properties

    var mock: TipCategory?
    
    // MARK: - Functions
    
    override func setUp() {
        super.setUp()
        
        mock = .planning
    }
    
    override func tearDown() {
        mock = nil
        
        super.tearDown()
    }
    
    // MARK: - Functions: Tests
    
    func testCategoryHasOutOfRangeErrorField() { XCTAssert(TipCategory.outOfRange.rawValue == -1)}
    
    func testCategoryHasElevenFieldsExcludingErrors() { XCTAssert(TipCategory.Max == 11) }
    
    func testPlanningIsFirst() { XCTAssert(TipCategory.planning.rawValue == 0) }
    
    func testOrganizationIsSecond() { XCTAssert(TipCategory.organization.rawValue == 1) }
    
    func testMarketingIsThird() { XCTAssert(TipCategory.marketing.rawValue == 2) }
    
    func testOperationIsFourth() { XCTAssert(TipCategory.operations.rawValue == 3) }
    
    func testTechnologyIsFifth() { XCTAssert(TipCategory.technology.rawValue == 4) }
    
    func testValueIsSixth() { XCTAssert(TipCategory.value.rawValue == 5) }
    
    func testEfficiencyIsSeventh() { XCTAssert(TipCategory.efficiency.rawValue == 6) }
    
    func testFiscalIsEighth() { XCTAssert(TipCategory.fiscal.rawValue == 7) }
    
    func testHRisNinth() { XCTAssert(TipCategory.hr.rawValue == 8) }
    
    func testSecurityIsTenth() { XCTAssert(TipCategory.security.rawValue == 9) }
    
    func testLegalIsEleventh() { XCTAssert(TipCategory.legal.rawValue == 10) }
}
