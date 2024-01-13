//
//  RemoteTransactionLoaderTest.swift
//  WorldOfPAYBACKTests
//
//  Created by Abdul Ahad on 12.01.24.
//

import XCTest
import WorldOfPAYBACK


final class RemoteTransactionLoaderTest: XCTestCase {
    
    func test_Init_DoesNotRequestDataFromUrl(){
        let (_,client) = makeSUT()
        
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    
    func test_load_RequestDataFromUrl(){
        let givenUrl = URL(string: "http://given-url.com")!
        let (sut,client) = makeSUT(url: givenUrl)
        
        
        sut.load{ _ in }
        
        
        XCTAssertEqual(client.requestedUrls,[givenUrl])
    }
    
    func test_loadTwice_RequestDataFromUrlTwice(){
        let givenUrl = URL(string: "http://given-url.com")!
        let (sut,client) = makeSUT(url: givenUrl)
        
        
        sut.load{ _ in }
        sut.load{ _ in }
        
        
        XCTAssertEqual(client.requestedUrls,[givenUrl,givenUrl])
    }
    
    func test_load_DeliversErrorOnClientError(){
        let (sut,client) = makeSUT()
        
        expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
        
    }
    
    func test_load_DeliversErrorOnNon200Error(){
        let (sut,client) = makeSUT()
        
        let samples = [100,201,300,400,500]
        samples.enumerated().forEach{ index, code in
            
            
            expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.invalidData)) {
                client.complete(withStatusCode: code, at:index, data: makeItemsJSON([]))
            }
            
            
        }
        
        
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        
        let (sut,client) = makeSUT()
        
        expect(sut: sut, expectedResult: .failure(RemoteTransactionLoader.Error.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
        
        
        
        
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, expectedResult: .success([])) {
            client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        }
        
        
        
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeTransaction(partnerDisplayName: "REWE Group", createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"), amount: 124, currency: "PBP")
        
        let item2 =
        makeTransaction(partnerDisplayName: "dm-dogerie markt", createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"), amount: 1240, currency: "PBP")
        let items = [item1.model,item2.model]
        
        expect(sut: sut, expectedResult: .success(items)) {
            client.complete(withStatusCode: 200, data: makeItemsJSON([item1.json,item2.json]))
        }
        
        
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteTransactionLoader? = RemoteTransactionLoader(url: url, client: client)
        
        var capturedResults = [TransactionLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    private func makeSUT(url:URL = anyURL()) -> (RemoteTransactionLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTransactionLoader(url: url, client: client)
        return (sut,client)
    }
    
    private func makeTransaction(partnerDisplayName: String, description: String? = nil,createdAt: (date: Date, iso8601String: String), amount: Int,currency:String, reference:String = "",category:Int = 1) -> (model: TransactionItem, json: [String: Any]) {
        
        let item = TransactionItem(partnerDisplayName: partnerDisplayName, bookingDate: createdAt.date, description: description, amount: amount, currency: currency)
        
        let json = [
            "partnerDisplayName": partnerDisplayName,
            "alias": [
                "reference": reference
            ],
            "category": category,
            "transactionDetail": [
                "description": description,
                "bookingDate" : createdAt.iso8601String,
                "value": [
                    "amount": amount,
                    "currency":currency
                ],
                
            ]
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    func expect(sut:RemoteTransactionLoader,expectedResult:RemoteTransactionLoader.Result,action:() -> Void,file: StaticString = #file, line: UInt = #line) {
        
        var expectedResult:RemoteTransactionLoader.Result = expectedResult
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { recievedResult in
            switch (recievedResult,expectedResult){
            case let (.success(recievedItems),.success(expectedItems)):
                XCTAssertEqual(recievedItems, expectedItems,file: file,line: line)
            case let (.failure(recievedError as RemoteTransactionLoader.Error),.failure(expectedError as RemoteTransactionLoader.Error)):
                XCTAssertEqual(recievedError, expectedError,file: file,line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(recievedResult) instead",file: file,line: line)
            }
            
        }
        exp.fulfill()
        
        action()
        wait(for: [exp], timeout: 1.0)
        
    }
    class HTTPClientSpy:HTTPClient{
        
        var messages = [(url:URL,Completion:(HTTPClient.Result) -> Void)]()
        var requestedUrls:[URL]{
            return messages.map{$0.url}
        }
        func get(from url: URL, Completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url,Completion))
        }
        
        func complete(with error:Error, at index:Int = 0){
            messages[index].Completion(.failure(error))
        }
        
        func complete(withStatusCode code:Int, at index:Int = 0, data:Data){
            let response = HTTPURLResponse(url: requestedUrls[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].Completion(.success((data,response)))
            
        }
    }
}
