////
////  MockServer.swift
////  WorldOfPAYBACK
////
////  Created by Abdul Ahad on 12.01.24.
////
//
//import Foundation
//
//public func anyNSError() -> NSError {
//    return NSError(domain: "any error", code: 0)
//}
//
//public func anyURL() -> URL {
//    return URL(string: "http://any-url.com")!
//}
//
//public func anyData() -> Data {
//    return Data("any data".utf8)
//}
//
//extension HTTPURLResponse {
//    convenience init(statusCode: Int) {
//                self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
//            }
//        }
//
//extension JSONHTTPClient{
//  
//   
//   private func readLocalJSONFile(forName name: String, httpUrlResponse200 :Bool = true, Completion:@escaping (HTTPClient.Result) -> Void)  {
//       
//       guard let filePath = Bundle.main.path(forResource: name, ofType: "json")
//       
//       
//        let fileUrl = URL(fileURLWithPath: filePath)
//        let data = try Data(contentsOf: fileUrl)
//        Completion(.success((data,HTTPURLResponse(statusCode: 200))))
//           } catch {
//               
//           }
//       let data = try? Data(contentsOf: fileUrl)
//       return data
//       
//   }
//}
