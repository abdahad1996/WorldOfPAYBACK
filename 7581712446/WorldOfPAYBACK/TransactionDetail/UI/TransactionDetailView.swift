//
//  TransactionDetailView.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import SwiftUI

struct TransactionDetailView:View {
    let viewModel: TransactionDetailViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.partnerDisplayName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

            if let description = viewModel.description {
                Text(description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                   
            }.padding()
             
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(viewModel: TransactionDetailViewModel(transaction: makeTransaction()))
    }
    
    private static func makeTransaction() -> TransactionItem{
        return TransactionItem(partnerDisplayName: "REWE Group",bookingDate: Date(timeIntervalSince1970: 1577881882), description: "Punkte sammeln", amount: 124, currency: "PBP",category: 1)
    }
    
}
