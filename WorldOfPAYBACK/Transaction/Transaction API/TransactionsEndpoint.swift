//
//  File.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation


public enum TransactionsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("t")
        }
    }
}
