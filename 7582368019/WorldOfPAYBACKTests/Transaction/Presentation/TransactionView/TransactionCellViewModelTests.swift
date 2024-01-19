//
//
//  TransactionCellViewModel.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 14.01.24.
//

import Foundation
import WorldOfPAYBACK
import XCTest

class TransactionCellViewModelTests: XCTestCase {

    func testTransactionCellViewModel() {
        // Given
        let components = DateComponents(
             
            year: 2020,
            month: 01,
            day: 01,
            hour: 12,
            minute: 31,
            second: 22
        )
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        
        let originalDate = Calendar.current.date(from: components)!
        
        let transactionItem = makeTransactionItem(partnerDisplayName: "REWE Group",description: "Punkte sammeln", createdAt: (originalDate, "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP")
        
        // When
        let viewModel = TransactionCellViewModel(transaction: transactionItem)
        
        
        // Then
        XCTAssertEqual(viewModel.partnerDisplayName, "REWE Group")
        XCTAssertEqual(viewModel.description, "Punkte sammeln")
        XCTAssertEqual(viewModel.bookingDate, "Jan 1, 2020 at 12:31 PM")
        XCTAssertEqual(viewModel.amount, "124")
        XCTAssertEqual(viewModel.currency, "PBP")
        
    }
    
    
}
