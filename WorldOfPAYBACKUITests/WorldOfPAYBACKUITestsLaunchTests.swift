//
//  WorldOfPAYBACKUITestsLaunchTests.swift
//  WorldOfPAYBACKUITests
//
//  Created by Abdul Ahad on 15.01.24.
//

import XCTest

final class WorldOfPAYBACKUITestsLaunchTests: XCTestCase {

    private var app: XCUIApplication!

       override func setUpWithError() throws {
           // Put setup code here. This method is called before the invocation of each test method in the class.

           continueAfterFailure = false

           app = XCUIApplication()
           app.launch()
       }


    func testNavigatingFromTransactionListToDetail() {
        TransactionScreen(app: app)
              .verifyMessage("REWE Group")
                .tapOnFilter(text: "Category 3")
                .tapOnFilter(text: "All")
                .tapOnCell(at: 0, text: "REWE Group")
        }
}
