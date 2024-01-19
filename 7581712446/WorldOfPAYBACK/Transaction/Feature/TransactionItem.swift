//
//  Transaction.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 11.01.24.
//

import Foundation

public struct TransactionItem:Hashable{
    public let partnerDisplayName: String
    public let bookingDate: Date
    public let description: String?
    public let amount: Int
    public let currency: String
    public let category:Int
    
   public init(partnerDisplayName: String, bookingDate: Date, description: String?, amount: Int, currency: String,category:Int) {
        self.partnerDisplayName = partnerDisplayName
        self.bookingDate = bookingDate
        self.description = description
        self.amount = amount
        self.currency = currency
        self.category = category
    }
}

extension TransactionItem:Identifiable {
    public var id: Date {
        return bookingDate
    }
    
    
    
    
}


