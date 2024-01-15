//
//  TransactionViewSnapshotTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import WorldOfPAYBACK
import SwiftUI
import XCTest

final class HomeViewSnapshotTests: XCTestCase {
    
    func test_homeViewIdleState() {
        let (sut,_) = makeSUT(state: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewLoadingState() {
        let (sut,_) = makeSUT(state: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewFailureState() {
        let (sut,_) = makeSUT(state: .failure(localized("GENERIC_CONNECTION_ERROR")))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewSuccessState() {
        let (sut,viewModel) = makeSUT(state: .success(HomeViewSnapshotTests.makeTransactions()))
        viewModel.getAllTransactions()
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func  makeSUT(state: TransactionViewModel.State) -> (TransactionsView<TransactionCell, TransactionfilterView, FloatingView>,TransactionViewModel) {
        let viewModel = TransactionViewModel(transactionLoader: RemoteLoaderStub())
        viewModel.getTransactionsState = state
        
        let view  = TransactionsView(viewModel: viewModel, showTransactionDetails: {_ in}) { transactionItem in
            TransactionCell(viewModel: TransactionCellViewModel(transaction: transactionItem))
        } transactionFilterView: { selectedFilter, categories in
            TransactionfilterView(selectedFilter: selectedFilter, categories: categories)
        } totalCountView: { total in
            FloatingView(count: total)
        }
        return (view,viewModel)
    }
    
    
    private static func makeTransactions() -> [TransactionItem] {
       [
        TransactionItem(partnerDisplayName: "REWE Group",bookingDate: Date(timeIntervalSince1970: 1577881882), description: "Punkte sammeln", amount: 124, currency: "PBP",category: 1),
          
        TransactionItem(partnerDisplayName: "dm-dogerie markt",bookingDate: Date(timeIntervalSince1970: 1598627222), description: "Punkte sammeln", amount: 1240, currency: "PBP",category: 1),
          
        TransactionItem(partnerDisplayName: "dm-dogerie markt", bookingDate:  Date(timeIntervalSince1970:  1668157145), description: nil, amount: 1240, currency: "PBP",category: 2),
           
       ]
   }
   private class RemoteLoaderStub:TransactionLoader{
        func load(completion: @escaping (TransactionLoader.Result) -> Void) {
            let transactions = makeTransactions()
            completion(.success(transactions))
        }
        
    }
}
