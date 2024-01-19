//
//  TransactionScreen.swift
//  WorldOfPAYBACKUITests
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct TransactionScreen: Screen {
    let app: XCUIApplication

    @discardableResult
    func tapOnCell(at Index: Int,text:String) -> Self {
        if verifyCellExists(with: Index){
            app.staticTexts[verticalCellID(with: Index)].firstMatch.tap()
            sleep(5)
        }
        sleep(5)
        return self
        
    }
    
    @discardableResult
    func verifyMessage(_ message: String) -> Self {
            let message = app.staticTexts[message]
            XCTAssertTrue(message.waitForExistence(timeout: 5))
            return self
        }
    

    @discardableResult func tapOnFilter(text:String) -> Self {
        app.buttons[text].tap()
        return self
    }
    
    func verifyCellExists(with number: Int) -> Bool {
           return app.staticTexts[verticalCellID(with: number)].exists
       }
    func verticalCellID(with number: Int) -> String {
            return "UICellVertical\(number)"
        }
}
