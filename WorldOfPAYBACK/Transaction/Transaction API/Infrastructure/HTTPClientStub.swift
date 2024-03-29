//
//  HTTPClientStub.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 12.01.24.
//

import Foundation

public func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

public class HTTPClientStub: HTTPClient {
    
    let isE2ETesting:Bool
    public init(isTesting:Bool = false) {
        self.isE2ETesting = isTesting
    }
    
    public func get(from url: URL, Completion: @escaping (HTTPClient.Result) -> Void) {
        let filePath = Bundle.main.path(forResource: "PBTransactions", ofType: "json")!
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try! Data(contentsOf: fileUrl)
        
        
       let randomBool =  Bool.random()
        
        if CommandLine.arguments.contains("success") || isE2ETesting {
            Completion(.success((data, HTTPURLResponse(statusCode: 200))))
            return
        }
        if CommandLine.arguments.contains("failure"){
            let error = NSError(domain: "", code: 1)
            Completion(.failure(error))
            return
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            if randomBool {
                    Completion(.success((data, HTTPURLResponse(statusCode: 200))))
                }
            
            else{
                let error = NSError(domain: "", code: 1)
                Completion(.failure(error))
            }
           
        })
    }
}





func loadJson(forFilename fileName: String) -> NSDictionary? {
    
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        if let data = NSData(contentsOf: url) {
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
                
                return dictionary
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
        }
        print("Error!! Unable to load  \(fileName).json")
    }
    
    return nil
}
