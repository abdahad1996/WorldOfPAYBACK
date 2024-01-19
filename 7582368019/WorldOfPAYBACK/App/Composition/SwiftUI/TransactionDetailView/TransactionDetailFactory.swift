//
//  TransactionViewFactory.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import SwiftUI

public final class TransactionDetailFactory {
    
    private let transactionItem: TransactionItem
    
     init(transactionItem: TransactionItem) {
        self.transactionItem = transactionItem
    }
 
     func makeTransactionListViewController(
    ) -> UIViewController {
        
        let viewModel = TransactionDetailViewModel(transaction: transactionItem)
        let view = TransactionDetailView(viewModel: viewModel)

        let controller = UIHostingController(rootView: view)
        controller.title = "TransactionDetail"
        return controller
    }
}
