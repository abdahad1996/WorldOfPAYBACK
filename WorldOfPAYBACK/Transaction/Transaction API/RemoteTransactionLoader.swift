//
//  RemoteTransactionLoader.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 11.01.24.
//

import Foundation

public class RemoteTransactionLoader: TransactionLoader {
    
    
    public typealias Result = TransactionLoader.Result
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else {
                return
            }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteTransactionLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    public func load() async throws -> [TransactionItem] {
        guard let (data,response) =  try? await client.get(from: url) else{
            throw Error.connectivity
        }
      
        let result =  RemoteTransactionLoader.map(data, from: response)
        switch result {
        case .success(let transactions):
            return transactions
        case .failure:
            throw Error.invalidData
        }
    
            
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let transactions = try RemoteTransactionsMapper.map(data, from: response)
            return .success(transactions)
        } catch {
            return .failure(error)
        }
    }
   
}
