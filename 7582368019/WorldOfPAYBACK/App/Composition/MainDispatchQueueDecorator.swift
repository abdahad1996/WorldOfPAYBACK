//
//  MainDispatchQueueDecorator.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 15.01.24.
//

import Foundation

final class MainQueueDispatchDecorator2: TransactionLoader {
    
    private let decoratee: TransactionLoader
    
    init(decoratee: TransactionLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (TransactionLoader.Result) -> Void) {
        decoratee.load { result in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
