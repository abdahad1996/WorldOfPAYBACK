//
//  TransactionViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//

import Foundation
import Combine

public final class TransactionViewModel: ObservableObject {

    public enum GetTransactionError: String, Swift.Error {
        case ConnectionError = "An error occured while fetching Transactions. Please try again later!"
    }
    
    @Published public var filteredCategory = -1
    @Published public var filteredTransactions = [TransactionItem]()
    @Published public var totalAmount = 0
   


    public enum State: Equatable {
        case idle
        case isLoading
        case failure(String)
        case success([TransactionItem])
    }
    private var totalCancellables: Set<AnyCancellable> = []

    private let transactionLoader: TransactionLoader

    @Published public var getTransactionsState: State = .idle
    
    
    public var categories = [Int]()
    public var UniqueCategories:[Int]{
        guard case let .success(transactionItems) = getTransactionsState else { return [] }
        categories = [-1]
        let localCategory = transactionItems.map{$0.category}
        let uniqueCategory =  Array(Set(localCategory))
        var sortedCategory = uniqueCategory.sorted { $0 < $1 }
        sortedCategory.insert(-1, at: 0)

         return  sortedCategory
    }
    

    public init(transactionLoader: TransactionLoader) {
        self.transactionLoader = transactionLoader

        $filteredCategory.sink {[weak self] value in
            guard case let .success(transactionItems) = self?.getTransactionsState else {
                self?.filteredTransactions = []
                return
            }
            
            if value == -1 {
                self?.filteredTransactions = transactionItems
                return
            }
            self?.filteredTransactions = transactionItems.filter { $0.category == value }

        }.store(in: &totalCancellables)
        
        self.$filteredTransactions
            .map { $0.map(\.amount).reduce(0, +) }
            .eraseToAnyPublisher()
            .assign(to: &$totalAmount)

    }


     public func getAllTransactions()  {
         getTransactionsState = .isLoading
         filteredCategory = -1
         transactionLoader.load {[weak self] result in
             guard let self = self else{
                 self?.getTransactionsState = .idle
                 return}
             switch result {
             case .success(let transactions):
                 self.getTransactionsState = .success(transactions)
                 self.filteredTransactions = transactions
             case .failure(_):
                 self.getTransactionsState = .failure(GetTransactionError.ConnectionError.rawValue)
                 
             }
         }

    }
}
