//
//  TANetworkTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

@testable import TANetwork
import XCTest

final class TANetworkTests: XCTestCase {
    var sut: TANetwork!
    var clientMock: TANetworkClientMock!
    
    override func setUp() {
        super.setUp()
        clientMock = TANetworkClientMock()
        sut = TANetwork(client: clientMock)
    }
    
    override func tearDown() {
        super.tearDown()
        clientMock = nil
        sut = nil
    }
    
    func test_perform_whenIt_succeeds_withHttpMethod_get() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest<DataStub>(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: ["header": "value"]
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        clientMock.dataToBeReturned = dataStubEncoded
        clientMock.responseToBeReturned = HTTPURLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        // Act
        let response = try await sut.perform(dummyRequest, for: DataStub.self)
        
        // Assert
        XCTAssertEqual(clientMock.urlRequest?.url, urlStub)
        XCTAssertEqual(clientMock.urlRequest?.allHTTPHeaderFields, ["header": "value"])
        XCTAssertEqual(clientMock.urlRequest?.httpMethod, "GET")
        XCTAssertNil(clientMock.urlRequest?.httpBody)
        XCTAssertEqual(response, dataStub)
    }
    
    func test_perform_whenIt_succeeds_withHttpMethod_post() async throws {
        // Arrange
        let bodyStub = DataStub(stub: "body")
        let dummyRequest = TANetworkRequest<DataStub>(
            url: "https://www.google.com",
            method: .post,
            body: bodyStub,
            headers: ["header": "value"]
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        clientMock.dataToBeReturned = dataStubEncoded
        clientMock.responseToBeReturned = HTTPURLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        // Act
        let response = try await sut.perform(dummyRequest, for: DataStub.self)
        
        // Assert
        let bodyData = try XCTUnwrap(clientMock.urlRequest?.httpBody)
        let decodedBody = try JSONDecoder().decode(DataStub.self, from: bodyData)
        
        XCTAssertEqual(clientMock.urlRequest?.url, urlStub)
        XCTAssertEqual(clientMock.urlRequest?.allHTTPHeaderFields, ["header": "value"])
        XCTAssertEqual(clientMock.urlRequest?.httpMethod, "POST")
        XCTAssertEqual(decodedBody, bodyStub)
        XCTAssertEqual(response, dataStub)
    }
    
    func test_perform_whenIt_fails_dueTo_invalidRequestFormat() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest<DataStub>(
            url: "",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        clientMock.dataToBeReturned = dataStubEncoded
        clientMock.responseToBeReturned = HTTPURLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        var errorReceived: TANetworkError = .requestFailed
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertNil(clientMock.urlRequest)
        XCTAssertEqual(errorReceived, .invalidRequestFormat)
    }
    
    func test_perform_whenIt_fails_dueTo_unexpectedResponseType() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest<DataStub>(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        clientMock.dataToBeReturned = dataStubEncoded
        clientMock.responseToBeReturned = URLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        var errorReceived: TANetworkError = .decodingFailed
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(clientMock.urlRequest?.url, urlStub)
        XCTAssertEqual(errorReceived, .unexpectedResponseType)
    }
    
    func test_perform_whenIt_fails_dueTo_unexpectedStatusCode() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest<DataStub>(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        clientMock.dataToBeReturned = dataStubEncoded
        clientMock.responseToBeReturned = try XCTUnwrap(
            HTTPURLResponse(
                url: urlStub,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )
        )
        var errorReceived: TANetworkError = .decodingFailed
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(clientMock.urlRequest?.url, urlStub)
        XCTAssertEqual(errorReceived, .unexpectedStatusCode)
    }
    
    func test_perform_whenIt_fails_dueTo_decodingFailed() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest<DataStub>(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        clientMock.dataToBeReturned = dataStubEncoded
        clientMock.responseToBeReturned = try XCTUnwrap(
            HTTPURLResponse(
                url: urlStub,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        var errorReceived: TANetworkError = .unexpectedStatusCode
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: String.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(clientMock.urlRequest?.url, urlStub)
        XCTAssertEqual(errorReceived, .decodingFailed)
    }
    
    func test_perform_whenIt_fails_dueTo_requestFailed() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest<DataStub>(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        clientMock.dataToBeReturned = dataStubEncoded
        clientMock.responseToBeReturned = try XCTUnwrap(
            HTTPURLResponse(
                url: urlStub,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        clientMock.shouldFail = true
        var errorReceived: TANetworkError = .unexpectedStatusCode
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(clientMock.urlRequest?.url, urlStub)
        XCTAssertEqual(errorReceived, .requestFailed)
    }
}

// MARK: - Test Doubles
final class TANetworkClientMock: TANetworkClient {
    var dataToBeReturned = Data()
    var responseToBeReturned = URLResponse(url: URL(string: "https://www.github.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    var shouldFail = false
    
    private(set) var urlRequest: URLRequest?
    
    func data(request: URLRequest) async throws -> (Data, URLResponse) {
        urlRequest = request
        
        if shouldFail {
            throw(URLError(.unknown))
        } else {
            return (dataToBeReturned, responseToBeReturned)
        }
    }
}

struct DataStub: Codable, Equatable {
    let stub: String
}
