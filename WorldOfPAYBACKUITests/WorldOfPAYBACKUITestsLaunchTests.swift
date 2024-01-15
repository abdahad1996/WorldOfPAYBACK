//
//  WorldOfPAYBACKUITestsLaunchTests.swift
//  WorldOfPAYBACKUITests
//
//  Created by Abdul Ahad on 15.01.24.
//

import XCTest

final class WorldOfPAYBACKUITestsLaunchTests: XCTestCase {

    private var app: XCUIApplication!

    fileprivate func launch(command:String = "success") {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [command]
        app.launch()
    }
    
//    override func setUpWithError() throws {
//        launch()
//       }


    func testNavigatingFromTransactionListToDetail() {
                launch(command: "success")
        TransactionScreen(app: app)
              .verifyMessage("REWE Group")
                .tapOnFilter(text: "Category 3")
                .tapOnFilter(text: "All")
                .tapOnCell(at: 0, text: "REWE Group")
        }
    
    func testNavigatingFromTransactionFails() {
        launch(command: "failure")
                TransactionScreen(app: app)
                      .verifyMessage("Couldn't connect to server")
              
    }
                        
    
        
}
