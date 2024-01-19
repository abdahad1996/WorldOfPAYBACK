//
//  DateFormatterHelperTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import XCTest
import WorldOfPAYBACK

class DateFormatterHelperTests: XCTestCase {

    func testDateFormattingWithDefaultLocale() {
        
        
        
        // Given
        let inputDate = Date(timeIntervalSince1970: 1642435200)
        
        
        // 19th January 2022
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        dateformatter.locale = .current
        let expectedFormattedString = dateformatter.string(from: inputDate)// Update this based on your expectations

        // When
        let formattedString = DateFormatterHelper.format(date: inputDate)

        // Then
        XCTAssertEqual(formattedString, expectedFormattedString, expectedFormattedString)
    }

    // Additional test cases can be added to cover different scenarios

    func testDateFormattingWithCustomLocale() {
        // Given
        let inputDate = Date(timeIntervalSince1970: 1642435200) // 19th January 2022
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        dateformatter.locale = Locale(identifier: "fr_FR")
        let expectedFormattedString = dateformatter.string(from: inputDate) // Update this based on your expectations

        // When
        let customLocale = Locale(identifier: "fr_FR") // French locale
        let formattedString = DateFormatterHelper.format(date: inputDate, locale: customLocale)

        // Then
        XCTAssertEqual(formattedString, expectedFormattedString, "Formatted date string with custom locale doesn't match the expected value.")
    }

    // Add more test cases to cover various scenarios, like different date styles, different locales, etc.

}

