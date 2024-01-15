//
//  TransactionViewFactory.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import SwiftUI

public final class TransactionFactory {
    private let loader: TransactionLoader
    
    init(loader: TransactionLoader) {
       self.loader = loader
   }
 
     func makeTransactionListViewController(
        selection: @escaping (TransactionItem) -> Void
    ) -> UIViewController {
        let mainQueueLoader = MainQueueDispatchDecorator2(decoratee: loader)
        let sortedLoader = SortingRemoteTransactionLoaderDecorator(loader: mainQueueLoader, sortingPolicy: SortingPolicy())
        let viewModel = TransactionViewModel(transactionLoader: sortedLoader)

        let view =  TransactionsView(viewModel: viewModel, showTransactionDetails: {  transactionItem in
           selection(transactionItem)
        }) { transactionItem in
            TransactionCell(viewModel: TransactionCellViewModel(transaction: transactionItem))
        } transactionFilterView: { selectedFilter, categories in
            TransactionfilterView(selectedFilter: selectedFilter, categories: categories)
        } totalCountView: { total in
            FloatingView(count: total)
        }.navigationTitle(TransactionViewModel.title).navigationBarTitleDisplayMode(.inline)

        let controller = UIHostingController(rootView: view)
        return controller
    }
}
