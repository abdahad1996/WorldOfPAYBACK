//
//  SortingRemoteTransactionLoader.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 13.01.24.
//

import Foundation
import XCTest
import WorldOfPAYBACK

final class SortingRemoteTransactionLoaderTest: XCTestCase {
    
    func test_Init_DoesNotCallLoad(){
        let (_,client) = makeSUT()
        
        
        XCTAssertTrue(client.messages.isEmpty)
    }
    
    
    func test_load_LoadsFromLoader(){
        let (sut,client) = makeSUT()
        
        
        sut.load{ _ in }
        
        
        XCTAssertEqual(client.messages.count,1)
    }
    
    func test_loadTwice_LoadsFromClientTwice(){
        let (sut,client) = makeSUT()
        
        
        sut.load{ _ in }
        sut.load{ _ in }
        
        XCTAssertEqual(client.messages.count,2)
    }
    
    
    func test_load_DeliversErrorOnClientError(){
        let (sut,client) = makeSUT()
        
        expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.connectivity)) {
            client.complete(with: .connectivity)
        }
        
    }
    
    func test_load_DeliversErrorOnClientInvalidDataError(){
        let (sut,client) = makeSUT()
        
        expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.invalidData)) {
            client.complete(with: .invalidData)
        }
        
    }
    


    func test_load_deliversNoItemsWhenClientCompletesWithEmptyTransactions() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, expectedResult: .success([])) {
            client.complete(items: [])
        }
        
        
        
    }
    
    func test_load_deliversSortedTransactionsWhenClientCompletesWithTransactions() {
        let (sut, client) = makeSUT()
        let item1 = makeTransactionItem(partnerDisplayName: "REWE Group",description: "Punkte sammeln", createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP")
        
        let item2 =
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"), amount: 1240, currency: "PBP")
        
        let item3 =
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: ( Date(timeIntervalSince1970:  1668157145), "2022-11-11T10:59:05+0200"), amount: 1240, currency: "PBP")
        
        
        
        let exp = expectation(description: "Wait for load completion")
        var sortedTransactions = [TransactionItem]()
        sut.load { result in
            switch result{
            case .success(let transactions):
                sortedTransactions = transactions
            case .failure(let error):
                XCTFail("expected success but got \(error) instead")
            }
            exp.fulfill()
        }
        
        let withOutSorteditems = [item1,item2,item3]
        client.complete(items: withOutSorteditems)
        
        
        let aftersortedItems = [item3,item2,item1]
        
        XCTAssertEqual(aftersortedItems, sortedTransactions)
        wait(for: [exp], timeout: 1.0)

    }
    

    //MARK: HELPERS
    private func makeSUT(url:URL = anyURL(),file: StaticString = #file, line: UInt = #line) -> (SortingRemoteTransactionLoaderDecorator,TransactionLoaderSpy) {
        let policy = SortingPolicy()
        let loader = TransactionLoaderSpy()
        let sut = SortingRemoteTransactionLoaderDecorator(loader: loader, sortingPolicy: policy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(policy, file: file, line: line)

        return (sut,loader)
    }
    
    
    func expect(sut:SortingRemoteTransactionLoaderDecorator,expectedResult:RemoteTransactionLoader.Result,action:() -> Void,file: StaticString = #file, line: UInt = #line) {
        
        let expectedResult:RemoteTransactionLoader.Result = expectedResult
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { recievedResult in
            switch (recievedResult,expectedResult){
            case let (.success(recievedItems),.success(expectedItems)):
                XCTAssertEqual(recievedItems, expectedItems,file: file,line: line)
            case let (.failure(recievedError as RemoteTransactionLoader.Error),.failure(expectedError as RemoteTransactionLoader.Error)):
                XCTAssertEqual(recievedError, expectedError,file: file,line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(recievedResult) instead",file: file,line: line)
            }
            
        }
        exp.fulfill()
        
        action()
        wait(for: [exp], timeout: 1.0)
        
    }
}
