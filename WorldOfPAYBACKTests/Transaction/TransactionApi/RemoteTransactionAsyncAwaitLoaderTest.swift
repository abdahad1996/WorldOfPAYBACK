//
//  RemoteTransactionLoaderTest.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 12.01.24.
//

import XCTest
import WorldOfPAYBACK


extension HTTPURLResponse{
    convenience init(statusCode:Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

final class RemoteTransactionAsyncAwaitLoaderTest: XCTestCase {
    
    func test_Init_DoesNotRequestDataFromUrl(){
        let anyValidResponse = (Data(),HTTPURLResponse(statusCode: 200))
        let (_,client) = makeSUT(clientResult: .success(anyValidResponse))
        
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    
    func test_load_RequestDataFromUrl() async {
        let givenUrl = URL(string: "http://given-url.com")!
        let anyValidResponse = (Data(),HTTPURLResponse(statusCode: 200))

        let (sut,client) = makeSUT(url: givenUrl,clientResult: .success(anyValidResponse))
        
        
       
        let _ = try? await sut.load()
        
        
        
        
        XCTAssertEqual(client.requestedUrls,[givenUrl])
    }
//    
    func test_loadTwice_RequestDataFromUrlTwice() async throws {
        let givenUrl = URL(string: "http://given-url.com")!
        let anyValidResponse = (Data(),HTTPURLResponse(statusCode: 200))

        let (sut,client) = makeSUT(url: givenUrl,clientResult: .success(anyValidResponse))
        
            let _ = try? await sut.load()
            let _ = try? await sut.load()

       
        
        XCTAssertEqual(client.requestedUrls,[givenUrl,givenUrl])
    }
//    
    func test_load_DeliversErrorOnClientError() async{
        let givenUrl = URL(string: "http://given-url.com")!
        let clientError = anyNSError()
        let (sut,_) = makeSUT(url: givenUrl,clientResult: .failure(clientError))
        
        await expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.connectivity))
        
    }
//    
    func test_load_DeliversErrorOnNon200Error() async{
        let givenUrl = URL(string: "http://given-url.com")!
        let anyResponse = (Data(),HTTPURLResponse(statusCode: 199))
        let (sut,_) = makeSUT(url: givenUrl,clientResult: .success(anyResponse))
        
        await expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.invalidData))
        
    }
//    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
                
        let givenUrl = URL(string: "http://given-url.com")!
        let anyResponse = (Data("invalid json".utf8),HTTPURLResponse(statusCode: 200))
        let (sut,client) = makeSUT(url: givenUrl,clientResult: .success(anyResponse))
        
        await expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.invalidData))
    
        
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() async {
        let givenUrl = URL(string: "http://given-url.com")!
        let validEmptyJson = makeItemsJSON([])
        let validResponse = (validEmptyJson,HTTPURLResponse(statusCode: 200))
        let (sut,client) = makeSUT(url: givenUrl,clientResult:.success(validResponse))
        
        await expect(sut: sut, expectedResult: .success([]))
    
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() async {
       
        let item1 = makeTransaction(partnerDisplayName: "REWE Group",description: "Punkte sammeln", createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP")
        
        let item2 =
        makeTransaction(partnerDisplayName: "dm-dogerie markt", createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"), amount: 1240, currency: "PBP")
        
        
        let givenUrl = URL(string: "http://given-url.com")!
        let validJsonData = makeItemsJSON([item1.json,item2.json])
        let validResponse = (validJsonData,HTTPURLResponse(statusCode: 200))
        let (sut,client) = makeSUT(url: givenUrl,clientResult:.success(validResponse))
        
        await expect(sut: sut, expectedResult: .success([item1.model,item2.model]))
    }
    
    
    //MARK: HELPERS
    private func makeSUT(url:URL = anyURL(),clientResult:HTTPClient.Result,file: StaticString = #file, line: UInt = #line) -> (RemoteTransactionLoader,HTTPClientSpy) {
        let client = HTTPClientSpy(result: clientResult)
        let sut = RemoteTransactionLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut,client)
    }
    
    
    func expect(sut:RemoteTransactionLoader,expectedResult:RemoteTransactionLoader.Result,file: StaticString = #file, line: UInt = #line) async  {
        
        let expectedResult:RemoteTransactionLoader.Result = expectedResult
        
        var recievedTransactions = [TransactionItem]()
        var recievedError: NSError?
        do {
            recievedTransactions = try await sut.load()
           
        }catch let error {
            recievedError = error as NSError
        }
        
        switch expectedResult {
        case .success(let expectedTransactions):
            XCTAssertEqual(expectedTransactions, recievedTransactions,file: file,line: line)
        case .failure(let expectedError):
            
            XCTAssertEqual(expectedError as NSError, recievedError,file: file,line: line)
        }
        
        
        
    }
    
    class HTTPClientSpy:HTTPClient{
        
        let result : HTTPClient.Result
        var requestedUrls = [URL]()
        
        init(result: HTTPClient.Result) {
            self.result = result
        }
        
        func get(from url: URL, Completion: @escaping (HTTPClient.Result) -> Void) {
            Completion(.failure(anyNSError()))
        }
        
        
        func get(from url:URL) async throws -> (Data, HTTPURLResponse){
            requestedUrls.append(url)
            return try result.get()
        }

        
        
    }

}
