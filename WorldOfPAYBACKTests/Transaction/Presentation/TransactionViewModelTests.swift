//
//  TransactionsViewModelTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 14.01.24.
//

import XCTest
import WorldOfPAYBACK

final class TransactionsViewModelTests: XCTestCase {

    func test_init_getsStateidle(){
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.getTransactionsState, .idle)
    }
    
    func test_getAllTransactions_LoadsWithConnectionErrorOnInvalidDataErrorFromLoader(){
        let (sut,loader) = makeSUT()
        
        expect(sut: sut, expectedResult: .failure(.ConnectionError)) {
            loader.complete(with: .invalidData)

        }
    }
    
    func test_getAllTransactions_LoadsWithConnectionErrorOnConnectivityErrorFromLoader(){
        let (sut,loader) = makeSUT()
        
        
        expect(sut: sut, expectedResult: .failure(.ConnectionError)) {
            loader.complete(with: .connectivity)

        }
    }
    
    func test_getAllTransactions_LoadsWithEmptyTransactionsOnEmptyTransactionsFromLoader(){
        let (sut,loader) = makeSUT()
        
        
        expect(sut: sut, expectedResult: .success([])) {
            loader.complete(items: [])

        }
    }
    
    func test_getAllTransactions_LoadsWithTransactionsOnTransactionsFromLoader(){
        let (sut,loader) = makeSUT()
        
        
        let item1 = makeTransactionItem(partnerDisplayName: "REWE Group",description: "Punkte sammeln", createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP")
        
        let item2 =
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"), amount: 1240, currency: "PBP")
        
        let item3 =
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: ( Date(timeIntervalSince1970:  1668157145), "2022-11-11T10:59:05+0200"), amount: 1240, currency: "PBP")
        
        let transactionItems = [item1,item2,item3]
        
        expect(sut: sut, expectedResult: .success(transactionItems)) {
            loader.complete(items: transactionItems)
            
        }
    }
    
    func test_getAllTransactions_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let loader = TransactionLoaderSpy()
        var sut: TransactionViewModel? = TransactionViewModel(transactionLoader: loader)
        
        sut?.getAllTransactions()
        XCTAssertEqual(sut?.getTransactionsState,.isLoading)

        sut = nil
        
        
        let item1 = makeTransactionItem(partnerDisplayName: "REWE Group",description: "Punkte sammeln", createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP")
        
        let item2 =
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"), amount: 1240, currency: "PBP")
        
        let item3 =
        makeTransactionItem(partnerDisplayName: "dm-dogerie markt", createdAt: ( Date(timeIntervalSince1970:  1668157145), "2022-11-11T10:59:05+0200"), amount: 1240, currency: "PBP")
        
        let transactionItems = [item1,item2,item3]
        loader.complete(items: transactionItems)
        
        XCTAssertNil(sut?.getTransactionsState)
    }
    
    private func expect(
        sut: TransactionViewModel
        ,expectedResult:TransactionViewModel.State, action: () -> Void){
        
        
        let exp = expectation(description: "Wait for load completion")
        sut.getAllTransactions()
        XCTAssertEqual(sut.getTransactionsState,.isLoading)
        
        exp.fulfill()
        
        action()
        XCTAssertEqual(sut.getTransactionsState,expectedResult)
        wait(for: [exp], timeout: 1.0)
        
        

    }
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (
        sut: TransactionViewModel,
        loader:TransactionLoaderSpy
    ) {
        let loader = TransactionLoaderSpy()
        let sut = TransactionViewModel(transactionLoader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
}
