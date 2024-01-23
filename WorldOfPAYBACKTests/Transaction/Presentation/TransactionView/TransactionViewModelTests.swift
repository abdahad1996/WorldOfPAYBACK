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
        
        expect(sut: sut, expectedResult: .failure(localized("GENERIC_CONNECTION_ERROR"))) {
            loader.complete(with: .invalidData)

        }
    }
    
    func test_getAllTransactions_LoadsWithConnectionErrorOnConnectivityErrorFromLoader(){
        let (sut,loader) = makeSUT()
        
        
        expect(sut: sut, expectedResult: .failure(localized("GENERIC_CONNECTION_ERROR"))) {
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
        
        let transactionItems = makeTransactions()
        
        expect(sut: sut, expectedResult: .success(transactionItems)) {
            loader.complete(items: transactionItems)
            
        }
    }
    
    func test_categories_mapsFromTransactionsToCategories(){
        let (sut,_) = makeSUT()
        let transactionItems = makeTransactions()
        
        sut.getTransactionsState = .success(transactionItems)
        
        
        let expectedCategories = [-1,1,2]
        XCTAssertEqual(sut.UniqueCategories, expectedCategories)
        
    }
    
    func test_filteredTransactions_minus1DoesNotfilterTransactionOnCategories(){
        let (sut,_) = makeSUT()
        let transactionItems = makeTransactions()
        
        sut.getTransactionsState = .success(transactionItems)
        sut.filteredCategory = -1
        
        let expectedTransactions = transactionItems
        XCTAssertEqual(sut.filteredTransactions, expectedTransactions)
        
    }
    
    func test_filteredTransactions_filterTransactionOnCategories(){
        let (sut,_) = makeSUT()
        let transactionItems = makeTransactions()
        
        sut.getTransactionsState = .success(transactionItems)
        sut.filteredCategory = 1
        
        let expectedTransactions = transactionItems.filter{$0.category == 1}
        XCTAssertEqual(sut.filteredTransactions, expectedTransactions)
        
    }
    
    func test_totalCount_CalculatesTotalAmountFromTransactions(){
        let (sut,_) = makeSUT()
        let transactionItems = makeTransactions()
        
        sut.getTransactionsState = .success(transactionItems)
        sut.filteredCategory = -1
        
        let totalAmount = transactionItems.reduce(0) { $0 + $1.amount }
        
        XCTAssertEqual(sut.totalAmount, totalAmount)
        
    }
    
    func test_totalCount_CalculatesTotalAmountFromfilterTransaction(){
        let (sut,_) = makeSUT()
        let transactionItems = makeTransactions()
        
        sut.getTransactionsState = .success(transactionItems)
        sut.filteredCategory = 1

        
        let filteredTransactions = transactionItems.filter{$0.category == 1}
        let totalAmount = filteredTransactions.reduce(0) { $0 + $1.amount }
        
        XCTAssertEqual(sut.totalAmount, totalAmount)
        
    }
    
    
    
    func test_getAllTransactions_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let loader = TransactionLoaderSpy()
        var sut: TransactionViewModel? = TransactionViewModel(transactionLoader: loader)
        
        sut?.getAllTransactions()
        XCTAssertEqual(sut?.getTransactionsState,.isLoading)
        sut = nil
        let transactionItems = makeTransactions()
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
