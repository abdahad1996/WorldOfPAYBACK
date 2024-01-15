//
//  SceneDelegate.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 11.01.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        HTTPClientStub()
    }()
    #if DEBUG
    private lazy var baseURL = URL(string: "https://api-test.payback.com/transactions")!
    #else
    private lazy var baseURL = URL(string: "https://api.payback.com/transactions")!
    #endif
     func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
         showTransactionFlow(scene)
    }

    
    private func showTransactionFlow(_ scene: UIWindowScene) {
        let navigationController = UINavigationController()
        let remoteLoader = RemoteTransactionLoader(url:baseURL,client: httpClient)
        let factory = TransactionFactory(loader:remoteLoader)
        let flow = TransactionFlow(navigationController: navigationController, factory: factory) { [weak self ] navigationController, item in
            self?.makeTransactionDetailFlow(navigationController, transaction: item)
        }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        flow.start()
    }
    
    private func makeTransactionDetailFlow(_ navController: UINavigationController, transaction: TransactionItem){
        let factory = TransactionDetailFactory(transactionItem: transaction)
        let flow = TransactionDetailFlow(navigationController: navController, factory: factory)

        
        flow.start()
    }
    
}

