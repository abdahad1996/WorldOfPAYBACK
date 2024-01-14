//
//  TransactionCellViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//

import Foundation

public class TransactionCellViewModel{
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
    
    public var bookingDate: String {
        format(date: transaction.bookingDate)
    }
    
    public var amount:String{
        "\(transaction.amount)"
    }
    
    public var currency:String{
        "\(transaction.currency)"
    }
     
}

extension TransactionCellViewModel {
    
     func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return dateFormatter.string(from: date)
    }
    
}

