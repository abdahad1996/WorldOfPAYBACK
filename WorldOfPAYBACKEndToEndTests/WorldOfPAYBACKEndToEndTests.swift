//
//  WorldOfPAYBACKEndToEndTests.swift
//  WorldOfPAYBACKEndToEndTests
//
//  Created by Abdul Ahad on 13.01.24.
//

import XCTest
import WorldOfPAYBACK

final class WorldOfPAYBACKEndToEndTests: XCTestCase {

    
    func test_endToEndTestServerGETTransactionResult_matchesFixedTestAccountData() {
        switch getTransactionResult() {
        case let .success( TransactionItem): 
            
            XCTAssertEqual(TransactionItem[0], expectedTransactionItem(at: 0))
            XCTAssertEqual(TransactionItem[1], expectedTransactionItem(at: 1))
            XCTAssertEqual(TransactionItem[2], expectedTransactionItem(at: 2))
            XCTAssertEqual(TransactionItem[3], expectedTransactionItem(at: 3))
            XCTAssertEqual(TransactionItem[4], expectedTransactionItem(at: 4))
            XCTAssertEqual(TransactionItem[5], expectedTransactionItem(at: 5))
            XCTAssertEqual(TransactionItem[6], expectedTransactionItem(at: 6))
            XCTAssertEqual(TransactionItem[7], expectedTransactionItem(at: 7))
            
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    // MARK: - Helpers
    
    private func getTransactionResult(file: StaticString = #file, line: UInt = #line) -> TransactionLoader.Result? {
        let loader = RemoteTransactionLoader(url: TransactionTestServerURL, client: StubClient())
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: TransactionLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private func expectedTransactionItem(at index: Int) -> TransactionItem {
        return TransactionItem(
            partnerDisplayName: partnerDisplayName(at: index), 
            bookingDate:  bookingDate(at: index),
            description: description(at: index),
            amount: amount(at: index),
            currency: currency(at: index),
            category: cateogry(at: index)
        )
        
    }
    
    
    private var TransactionTestServerURL: URL {
        return URL(string: "https://api-test.payback.com/transactions")!
    }
    
    private func StubClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = HTTPClientStub()
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    private func partnerDisplayName(at index: Int) -> String {
        return [
            "REWE Group",
            "dm-dogerie markt",
            "OTTO Group",
            "OTTO Group",
            "H&M",
            "DEPOT",
            "Tchibo",
            "REWE Group",
        ][index]
    }
    
    private func description(at index: Int) -> String? {
        return [
            "Punkte sammeln",
            "Punkte sammeln",
            nil,
            "Punkte sammeln",
            "Punkte sammeln",
            "Punkte sammeln",
            "Punkte sammeln",
            "Punkte sammeln",
        ][index]
    }
    
    private func amount(at index: Int) -> Int {
        return [
            124,
            1240,
            53,
            353,
            43,
            75,
            12,
            86,
        ][index]
    }
    
    private func bookingDate(at index: Int) -> Date{
        return [
            Date(timeIntervalSince1970:  1658653145),
            Date(timeIntervalSince1970:  1655974745),
            Date(timeIntervalSince1970:  1658480345),
            Date(timeIntervalSince1970:  1649581145),
            Date(timeIntervalSince1970:  1648198745),
            Date(timeIntervalSince1970:  1663837145),
            Date(timeIntervalSince1970:  1666601945),
            Date(timeIntervalSince1970:  1668157145)
        ][index]
    }
    
    private func currency(at index: Int) -> String{
        return [
            "PBP",
            "PBP",
            "PBP",
            "PBP",
            "PBP",
            "PBP",
            "PBP",
            "PBP",
        ][index]
    }
    
    private func cateogry(at index: Int) -> Int{
        return [
            1,
            1,
            2,
            1,
            1,
            2,
            1,
            3,
        ][index]
    }
}
