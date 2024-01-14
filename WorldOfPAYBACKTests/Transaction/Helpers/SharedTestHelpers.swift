//
//  SharedTestHelpers.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 12.01.24.
//

import Foundation
import WorldOfPAYBACK

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeTransactionItem(partnerDisplayName: String, description: String? = nil,createdAt: (date: Date, iso8601String: String), amount: Int,currency:String, reference:String = "",category:Int = 1) -> TransactionItem{
    return TransactionItem(partnerDisplayName: partnerDisplayName, bookingDate: createdAt.date, description: description, amount: amount, currency: currency)
}

 func makeTransaction(partnerDisplayName: String, description: String? = nil,createdAt: (date: Date, iso8601String: String), amount: Int,currency:String, reference:String = "",category:Int = 1) -> (model: TransactionItem, json: [String: Any]) {
    
    let item = TransactionItem(partnerDisplayName: partnerDisplayName, bookingDate: createdAt.date, description: description, amount: amount, currency: currency)
    
    let json = [
        "partnerDisplayName": partnerDisplayName,
        "alias": [
            "reference": reference
        ],
        "category": category,
        "transactionDetail": [
            "description": description as Any,
            "bookingDate" : createdAt.iso8601String,
            "value": [
                "amount": amount,
                "currency":currency
            ],
            
        ]
    ].compactMapValues { $0 }
    
    return (item, json)
}
 func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
}
