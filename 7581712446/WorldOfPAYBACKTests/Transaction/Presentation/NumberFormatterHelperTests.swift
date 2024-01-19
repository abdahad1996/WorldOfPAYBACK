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
        let number = NSNumber(value:amount)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let expectedFormattedString =  numberFormatter.string(from: number) ?? "\(amount)"

        // When
        let formattedString = NumberFormatterHelper.formattedCurrency(amount: amount)

        // Then
        XCTAssertEqual(formattedString, expectedFormattedString, "Formatted currency string doesn't match the expected value.")
    }

    // Additional test cases can be added to cover different scenarios

    func testFormattedCurrencyWithZeroAmount() {
        // Given
        let amount = 0
        let number = NSNumber(value:amount)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let expectedFormattedString =  numberFormatter.string(from: number) ?? "\(amount)"


        // When
        let formattedString = NumberFormatterHelper.formattedCurrency(amount: amount)

        // Then
        XCTAssertEqual(formattedString, expectedFormattedString, "Formatted currency string doesn't match the expected value for zero amount.")
    }


}
