//
//  TransactionDetailViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//

import Foundation

public class TransactionDetailViewModel{
    private let transaction:TransactionItem
    
    public init(transaction: TransactionItem) {
        self.transaction = transaction
    }
    
    public var partnerDisplayName: String {
        transaction.partnerDisplayName
    }
    
    public var description: String? {
        transaction.description
    }
}
