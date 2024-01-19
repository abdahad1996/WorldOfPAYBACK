//
//  HTTPClient.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 12.01.24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url:URL) async throws -> (Data, HTTPURLResponse)
    func get(from url:URL, Completion:@escaping (Result)-> Void )
    
}

public extension HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            self.get(from: url) { result in
                switch result {
                case .success((let data, let response)):
                    return continuation.resume(returning: (data, response))
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
}
