//
//  NumberFormatterTest.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import XCTest
import WorldOfPAYBACK

class NumberFormatterHelperTests: XCTestCase {

    func testFormattedCurrency() {
        // Given
        let amount = 1234
        let expectedFormattedString = "1.234,00 €"

        // When
        let formattedString = NumberFormatterHelper.formattedCurrency(amount: amount)

        // Then
        XCTAssertEqual(formattedString, expectedFormattedString, "Formatted currency string doesn't match the expected value.")
    }

    // Additional test cases can be added to cover different scenarios

    func testFormattedCurrencyWithZeroAmount() {
        // Given
        let amount = 0
        let expectedFormattedString = "0,00 €"

        // When
        let formattedString = NumberFormatterHelper.formattedCurrency(amount: amount)

        // Then
        XCTAssertEqual(formattedString, expectedFormattedString, "Formatted currency string doesn't match the expected value for zero amount.")
    }

    // Add more test cases to cover various scenarios, like different currency codes, negative amounts, etc.

}
