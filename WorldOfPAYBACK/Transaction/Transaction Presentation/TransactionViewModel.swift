//
//  TransactionViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//

import Foundation

public final class TransactionViewModel: ObservableObject {

    public enum GetTransactionError: String, Swift.Error {
        case ConnectionError = "An error occured while fetching Transactions. Please try again later!"
    }

    public enum State: Equatable {
        case idle
        case isLoading
        case failure(GetTransactionError)
        case success([TransactionItem])
    }

    private let transactionLoader: TransactionLoader

    @Published public var getTransactionsState: State = .idle

    public init(transactionLoader: TransactionLoader) {
        self.transactionLoader = transactionLoader
    }


     public func getAllTransactions()  {
         getTransactionsState = .isLoading
         transactionLoader.load {[weak self] result in
             guard let self = self else{
                 self?.getTransactionsState = .idle
                 return}
             switch result {
             case .success(let transactions):
                 self.getTransactionsState = .success(transactions)
             case .failure(_):
                 self.getTransactionsState = .failure(.ConnectionError)
             }
         }

    }
}
