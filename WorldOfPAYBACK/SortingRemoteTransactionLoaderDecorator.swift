//
//  SortingRemoteTransactionLoader.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 13.01.24.
//

import Foundation

public class SortingRemoteTransactionLoaderDecorator: TransactionLoader {
    
    private let loader : TransactionLoader
    private let sortingPolicy:SortingPolicy
    public typealias Result = TransactionLoader.Result

    public init(loader: TransactionLoader, sortingPolicy: SortingPolicy) {
        self.loader = loader
        self.sortingPolicy = sortingPolicy
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        loader.load { result in
            switch result {
            case .success(let transactions):
                let sortedTransactions =  SortingPolicy.sortItems(items: transactions, by: .bookingDate, direction: .descending)
                completion(.success(sortedTransactions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
