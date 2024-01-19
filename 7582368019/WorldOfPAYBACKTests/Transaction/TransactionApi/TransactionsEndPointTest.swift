//
//  TransactionsEndPointTest.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import WorldOfPAYBACK
import XCTest

class TransactionsEndpointTests: XCTestCase {
    
    func test_transactions_endpointURL() {
        let baseURL = URL(string: "https://api.payback.com")!
        
        let received = TransactionsEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "https://api.payback.com/transactions")!
        
        XCTAssertEqual(received, expected)
    }
    
}
