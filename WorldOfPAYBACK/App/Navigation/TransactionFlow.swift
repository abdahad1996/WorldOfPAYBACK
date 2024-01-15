//
//  TransactionFlow.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import UIKit

final class TransactionFlow {
    private let navigationController: UINavigationController
    private let factory: TransactionFactory
    private let makeUserDetailsController: (UINavigationController, TransactionItem) -> Void
    init(
        navigationController: UINavigationController,
        factory: TransactionFactory,
        makeUserDetailsController:@escaping (UINavigationController, TransactionItem) -> Void
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.makeUserDetailsController = makeUserDetailsController
    }
    
    func start() {
        let vc = factory.makeTransactionListViewController(selection: showTransactionDetail)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showTransactionDetail(with transaction: TransactionItem) {
        self.makeUserDetailsController(navigationController, transaction)
        

    }
}
