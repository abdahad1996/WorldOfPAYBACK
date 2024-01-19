//
//  TransactionLoaderSpy.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 14.01.24.
//

import Foundation
import WorldOfPAYBACK

 class TransactionLoaderSpy:TransactionLoader {
    private(set) var messages =  [(TransactionLoader.Result) -> Void]()

    func load(completion: @escaping (TransactionLoader.Result) -> Void) {
        messages.append(completion)
    }
    func complete(at Index: Int = 0 ,items:[TransactionItem]){
        messages[Index](.success(items))
    }
    func complete(with error:RemoteTransactionLoader.Error, at index:Int = 0){
        messages[index](.failure(error))
    }
    
}
