//
//  SharedTestHelpers.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 12.01.24.
//

import Foundation
import WorldOfPAYBACK
import SwiftUI
import SnapshotTesting
import XCTest

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

 func makeTransactions() -> [TransactionItem] {
    [
        makeTransactionItem(partnerDisplayName: "REWE Group",description: "Punkte sammeln", createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP",category: 1),
       
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"), amount: 1240, currency: "PBP",category: 1),
       
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: ( Date(timeIntervalSince1970:  1668157145), "2022-11-11T10:59:05+0200"), amount: 1240, currency: "PBP",category: 2),
        
    ]
}

func makeTransactionItem(partnerDisplayName: String, description: String? = nil,createdAt: (date: Date, iso8601String: String), amount: Int,currency:String, reference:String = "",category:Int = 1) -> TransactionItem{
    return TransactionItem(partnerDisplayName: partnerDisplayName, bookingDate: createdAt.date, description: description, amount: amount, currency: currency, category: category)
}

 func makeTransaction(partnerDisplayName: String, description: String? = nil,createdAt: (date: Date, iso8601String: String), amount: Int,currency:String, reference:String = "",category:Int = 1) -> (model: TransactionItem, json: [String: Any]) {
    
     let item = TransactionItem(partnerDisplayName: partnerDisplayName, bookingDate: createdAt.date, description: description, amount: amount, currency: currency, category: category)
    
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



func assertLightSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .light)
    let view = UIHostingController(rootView: value)

    assertSnapshot(matching: view,
                   as: .image(on: .iPhone13, perceptualPrecision: 0.99, traits: trait),
                   named: "light",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}

func assertDarkSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .dark)
    let view = UIHostingController(rootView: value)

    assertSnapshot(matching: view,
                   as: .image(on: .iPhone13, perceptualPrecision: 0.99, traits: trait),
                   named: "dark",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}
