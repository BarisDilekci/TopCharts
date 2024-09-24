//
//  TopChartsTests.swift
//  TopChartsTests
//
//  Created by Barış Dilekçi on 24.09.2024.
//

import XCTest
@testable import TopCharts

struct MyDataType: Codable {
    let key: String
}

class TopChartsTests: XCTestCase {
    
    var mockSession: MockURLSession!
    var client: Client!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        client = Client(session: mockSession)
    }
    
    func testFetchSuccess() async {
        let mockData = """
        { "key": "value" }
        """.data(using: .utf8)
        
        let mockResponse = HTTPURLResponse(url: URL(string: "https://api.example.com")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)
        
        mockSession.data = mockData
        mockSession.response = mockResponse
        
        do {
            let request = URLRequest(url: URL(string: "https://api.example.com")!)
            let result: MyDataType = try await client.fetch(type: MyDataType.self, with: request)
            XCTAssertEqual(result.key, "value")
        } catch {
            XCTFail("Beklenmeyen hata: \(error)")
        }
    }
    
    func testFetchErrorInvalidResponse() async {
        mockSession.response = URLResponse()
        let request = URLRequest(url: URL(string: "https://api.example.com")!)
        
        do {
            _ = try await client.fetch(type: MyDataType.self, with: request)
            XCTFail("Hata bekleniyordu ama başarılı oldu.")
        } catch let apiError as APIError {
            XCTAssertEqual(apiError, APIError.requestFailed(description: "Invalid Response"))
        } catch {
            XCTFail("Beklenmeyen hata: \(error)")
        }
    }
    
    func testFetchErrorStatusCode() async {
        let mockResponse = HTTPURLResponse(url: URL(string: "https://api.example.com")!,
                                            statusCode: 404,
                                            httpVersion: nil,
                                            headerFields: nil)
        
        mockSession.data = Data() 
        mockSession.response = mockResponse
        
        let request = URLRequest(url: URL(string: "https://api.example.com")!)
        
        do {
            _ = try await client.fetch(type: MyDataType.self, with: request)
            XCTFail("Hata bekleniyordu ama başarılı oldu.")
        } catch let apiError as APIError {
            XCTAssertEqual(apiError, APIError.responseUnsuccessful(description: "Status code: 404"))
        } catch {
            XCTFail("Beklenmeyen hata: \(error)")
        }
    }
    
    
}
