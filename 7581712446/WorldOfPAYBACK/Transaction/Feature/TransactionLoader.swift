//
//  TransactionLoader.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 11.01.24.
//

import Foundation

public protocol TransactionLoader {
    typealias Result = Swift.Result<[TransactionItem], Error>
    
    func load() async throws -> [TransactionItem]
    func load(completion: @escaping (Result) -> Void)
}

extension TransactionLoader {
    public func load() async throws -> [TransactionItem] {
        return try await withCheckedThrowingContinuation { continuation in
            self.load{ result in
                switch result {
                case .success(let transactionItem):
                    continuation.resume(with: .success(transactionItem))
                case .failure(let err):
                    continuation.resume(throwing: err)
                }
            }
        }
    }
}
