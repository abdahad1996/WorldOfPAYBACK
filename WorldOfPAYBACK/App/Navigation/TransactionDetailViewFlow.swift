//
//  TransactionDetailViewFlow.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation
import UIKit

final class TransactionDetailFlow {
    private let navigationController: UINavigationController
    private let factory: TransactionDetailFactory
    
    init(
        navigationController: UINavigationController,
        factory: TransactionDetailFactory
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let vc = factory.makeTransactionListViewController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
