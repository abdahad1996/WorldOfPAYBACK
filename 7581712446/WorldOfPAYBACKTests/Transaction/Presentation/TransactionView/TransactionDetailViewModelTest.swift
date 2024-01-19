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

class TransactionDetailViewModelTests: XCTestCase {

    func testTransactionCellViewModel() {
        // Given
        let transactionItem = makeTransactionItem(partnerDisplayName: "REWE Group",description: "Punkte sammeln", createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP")
        
        // When
        let viewModel = TransactionDetailViewModel(transaction: transactionItem)
        
        
        // Then
        XCTAssertEqual(viewModel.partnerDisplayName, "REWE Group")
        XCTAssertEqual(viewModel.description, "Punkte sammeln")
        
        
    }
    
    
}
