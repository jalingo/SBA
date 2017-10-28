//
//  CategoryTests.swift
//  Small Business AdvisorTests
//
//  Created by James Lingo on 10/25/17.
//  Copyright © 2017 Escape Chaos. All rights reserved.
//

import XCTest

class TipCategoryTests: XCTestCase {
    
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
    
    func testCategoryHasElevenFieldsExcludingErrors() { XCTAssert(TipCategory.max == 11) }
    
    func testPlanningIsFirst() { XCTAssert(TipCategory.planning.rawValue == 0) }

    func testPlanningHasIndexRange() { XCTAssert(TipCategory.planning.indexRange == 1...23) }

    func testOrganizationIsSecond() { XCTAssert(TipCategory.organization.rawValue == 1) }
    
    func testOrganizationHasIndexRange() { XCTAssert(TipCategory.organization.indexRange == 24...28) }
    
    func testMarketingIsThird() { XCTAssert(TipCategory.marketing.rawValue == 2) }

    func testMarketingHasIndexRange() { XCTAssert(TipCategory.marketing.indexRange == 29...45) }
    
    func testOperationIsFourth() { XCTAssert(TipCategory.operations.rawValue == 3) }
    
    func testOperationsHasIndexRange() { XCTAssert(TipCategory.operations.indexRange == 46...50) }
    
    func testTechnologyIsFifth() { XCTAssert(TipCategory.technology.rawValue == 4) }
    
    func testTechnologyHasIndexRange() { XCTAssert(TipCategory.technology.indexRange == 51...61) }
    
    func testValueIsSixth() { XCTAssert(TipCategory.value.rawValue == 5) }
    
    func testValueHasIndexRange() { XCTAssert(TipCategory.value.indexRange == 62...65) }
    
    func testEfficiencyIsSeventh() { XCTAssert(TipCategory.efficiency.rawValue == 6) }
    
    func testEfficiencyHasIndexRange() { XCTAssert(TipCategory.efficiency.indexRange == 66...70) }
    
    func testFiscalIsEighth() { XCTAssert(TipCategory.fiscal.rawValue == 7) }
    
    func testTiscalHasIndexRange() { XCTAssert(TipCategory.fiscal.indexRange == 71...89) }
    
    func testHRisNinth() { XCTAssert(TipCategory.hr.rawValue == 8) }

    func testHrHasIndexRange() { XCTAssert(TipCategory.hr.indexRange == 90...95) }
    
    func testSecurityIsTenth() { XCTAssert(TipCategory.security.rawValue == 9) }
    
    func testSecurityHasIndexRange() { XCTAssert(TipCategory.security.indexRange == 96...99) }
    
    func testLegalIsEleventh() { XCTAssert(TipCategory.legal.rawValue == 10) }
    
    func testLegalHasIndexRange() { XCTAssert(TipCategory.legal.indexRange == 100...105) }
}
