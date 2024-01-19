//
//  RemoteTransactionsMapper.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 12.01.24.
//

import Foundation

public class RemoteTransactionsMapper {
    private struct Root: Decodable {
        private let items: [RemoteTransactionItem]
        
        private struct RemoteTransactionItem: Decodable {
            let partnerDisplayName: String
            let alias: Alias
            let category: Int
            let transactionDetail: TransactionDetail
        }
        
        struct Alias: Decodable {
            let reference: String
        }

        struct TransactionDetail: Decodable {
            let description: String?
            let bookingDate: Date
            let value: Value
        }

        struct Value: Decodable {
            let amount: Int
            let currency: String
        }
        
        var transactionItems: [TransactionItem] {
           
            items.map {
                TransactionItem(partnerDisplayName: $0.partnerDisplayName, bookingDate: $0.transactionDetail.bookingDate, description:  $0.transactionDetail.description, amount: $0.transactionDetail.value.amount, currency: $0.transactionDetail.value.currency, category: $0.category) }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [TransactionItem] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw  RemoteTransactionLoader.Error.invalidData
        }
        
        return root.transactionItems
    }
}


