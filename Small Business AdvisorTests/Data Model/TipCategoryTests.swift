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
    
    let formatting = CategoryFormatting()

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
    
    func testPlanningHasAttributedString() {
        XCTAssert(TipCategory.planning.formatted == NSMutableAttributedString(string: "Planning", attributes: formatting))
    }

    func testOrganizationIsSecond() { XCTAssert(TipCategory.organization.rawValue == 1) }
    
    func testOrganizationHasIndexRange() { XCTAssert(TipCategory.organization.indexRange == 24...28) }
    
    func testOrganizationHasAttributedString() {
        XCTAssert(TipCategory.organization.formatted == NSMutableAttributedString(string: "Organization", attributes: formatting))
    }
    
    func testMarketingIsThird() { XCTAssert(TipCategory.marketing.rawValue == 2) }

    func testMarketingHasIndexRange() { XCTAssert(TipCategory.marketing.indexRange == 29...45) }
    
    func testMarketingHasAttributedString() {
        XCTAssert(TipCategory.marketing.formatted == NSMutableAttributedString(string: "Marketing", attributes: formatting))
    }
    
    func testOperationIsFourth() { XCTAssert(TipCategory.operations.rawValue == 3) }
    
    func testOperationsHasIndexRange() { XCTAssert(TipCategory.operations.indexRange == 46...50) }
    
    func testOperationsHasAttributedString() {
        XCTAssert(TipCategory.operations.formatted == NSMutableAttributedString(string: "Operations", attributes: formatting))
    }
    
    func testTechnologyIsFifth() { XCTAssert(TipCategory.technology.rawValue == 4) }
    
    func testTechnologyHasIndexRange() { XCTAssert(TipCategory.technology.indexRange == 51...61) }
    
    func testTechnologyHasAttributedString() {
        XCTAssert(TipCategory.technology.formatted == NSMutableAttributedString(string: "Technology", attributes: formatting))
    }
    
    func testValueIsSixth() { XCTAssert(TipCategory.value.rawValue == 5) }
    
    func testValueHasIndexRange() { XCTAssert(TipCategory.value.indexRange == 62...65) }
    
    func testValueHasAttributedString() {
        XCTAssert(TipCategory.value.formatted == NSMutableAttributedString(string: "Value", attributes: formatting))
    }
    
    func testEfficiencyIsSeventh() { XCTAssert(TipCategory.efficiency.rawValue == 6) }
    
    func testEfficiencyHasIndexRange() { XCTAssert(TipCategory.efficiency.indexRange == 66...70) }
    
    func testEfficiencyHasAttributedString() {
        XCTAssert(TipCategory.efficiency.formatted == NSMutableAttributedString(string: "Efficiency", attributes: formatting))
    }
    
    func testFiscalIsEighth() { XCTAssert(TipCategory.fiscal.rawValue == 7) }
    
    func testFiscalHasIndexRange() { XCTAssert(TipCategory.fiscal.indexRange == 71...89) }
   
    func testFiscalHasAttributedString() {
        XCTAssert(TipCategory.fiscal.formatted == NSMutableAttributedString(string: "Fiscal", attributes: formatting))
    }
    
    func testHrIsNinth() { XCTAssert(TipCategory.hr.rawValue == 8) }

    func testHrHasIndexRange() { XCTAssert(TipCategory.hr.indexRange == 90...95) }
    
    func testHrHasAttributedString() {
        XCTAssert(TipCategory.hr.formatted == NSMutableAttributedString(string: "Human Resources", attributes: formatting))
    }
    
    func testSecurityIsTenth() { XCTAssert(TipCategory.security.rawValue == 9) }
    
    func testSecurityHasIndexRange() { XCTAssert(TipCategory.security.indexRange == 96...99) }
    
    func testSecurityHasAttributedString() {
        XCTAssert(TipCategory.security.formatted == NSMutableAttributedString(string: "Security", attributes: formatting))
    }
    
    func testLegalIsEleventh() { XCTAssert(TipCategory.legal.rawValue == 10) }
    
    func testLegalHasIndexRange() { XCTAssert(TipCategory.legal.indexRange == 100...105) }

    func testLegalHasAttributedString() {
        XCTAssert(TipCategory.legal.formatted == NSMutableAttributedString(string: "Legal", attributes: formatting))
    }
}
