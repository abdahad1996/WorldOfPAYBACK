//
//  TransactionLoader.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 11.01.24.
//

import Foundation

public protocol TransactionLoader {
    typealias Result = Swift.Result<[Transaction], Error>
    
    func load(from url:URL) async throws -> [Transaction]
    func load(from url:URL,completion: @escaping (Result) -> Void)
}
extension TransactionLoader {
    func load(from url:URL) async throws -> [Transaction] {
        return try await withCheckedThrowingContinuation { continuation in
            self.load(from: url) { result in
                switch result {
                case .success(let transaction):
                    continuation.resume(with: .success(transaction))
                case .failure(let err):
                    continuation.resume(throwing: err)
                }
            }
        }
    }
}
