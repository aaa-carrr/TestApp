//
//  TANetworkTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

@testable import TANetwork
import XCTest

// Initially, I wrote more assertions to check if the `URLRequest` constructed inside `TANetwork`
// was actually constructed correctly. However, due to the `Sendable` required I had issues creating
// a mutable mock to allow mutating a variable to contain the request constructed.
// See commit `fa9b25e` for the tests using a more "standard" mock.

final class TANetworkTests: XCTestCase {
    func test_perform_whenIt_succeeds_withHttpMethod_get() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: ["header": "value"]
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponseStub = HTTPURLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        let clientMock = TANetworkClientMock(
            dataToBeReturned: dataStubEncoded,
            responseToBeReturned: urlResponseStub,
            shouldFail: false
        )
        
        let sut = TANetwork(client: clientMock)
        
        // Act
        let response = try await sut.perform(dummyRequest, for: DataStub.self)
        
        // Assert
        XCTAssertEqual(response, dataStub)
    }
    
    func test_perform_whenIt_succeeds_withHttpMethod_post() async throws {
        // Arrange
        let bodyStub = DataStub(stub: "body")
        let dummyRequest = TANetworkRequest(
            url: "https://www.google.com",
            method: .post,
            body: bodyStub,
            headers: ["header": "value"]
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponseStub = HTTPURLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        let clientMock = TANetworkClientMock(
            dataToBeReturned: dataStubEncoded,
            responseToBeReturned: urlResponseStub,
            shouldFail: false
        )
        
        let sut = TANetwork(client: clientMock)
        
        // Act
        let response = try await sut.perform(dummyRequest, for: DataStub.self)
        
        // Assert
        XCTAssertEqual(response, dataStub)
    }
    
    func test_perform_whenIt_fails_dueTo_invalidRequestFormat() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest(
            url: "",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponseStub = HTTPURLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        let clientMock = TANetworkClientMock(
            dataToBeReturned: dataStubEncoded,
            responseToBeReturned: urlResponseStub,
            shouldFail: false
        )
        
        let sut = TANetwork(client: clientMock)
        
        var errorReceived: TANetworkError = .requestFailed
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(errorReceived, .invalidRequestFormat)
    }
    
    func test_perform_whenIt_fails_dueTo_unexpectedResponseType() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponseStub = URLResponse(
            url: urlStub,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        let clientMock = TANetworkClientMock(
            dataToBeReturned: dataStubEncoded,
            responseToBeReturned: urlResponseStub,
            shouldFail: false
        )
        
        let sut = TANetwork(client: clientMock)
        
        var errorReceived: TANetworkError = .decodingFailed
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(errorReceived, .unexpectedResponseType)
    }
    
    func test_perform_whenIt_fails_dueTo_unexpectedStatusCode() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponseStub = try XCTUnwrap(
            HTTPURLResponse(
                url: urlStub,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        let clientMock = TANetworkClientMock(
            dataToBeReturned: dataStubEncoded,
            responseToBeReturned: urlResponseStub,
            shouldFail: false
        )
        
        let sut = TANetwork(client: clientMock)
        
        var errorReceived: TANetworkError = .decodingFailed
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(errorReceived, .unexpectedStatusCode)
    }
    
    func test_perform_whenIt_fails_dueTo_decodingFailed() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponseStub = try XCTUnwrap(
            HTTPURLResponse(
                url: urlStub,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        let clientMock = TANetworkClientMock(
            dataToBeReturned: dataStubEncoded,
            responseToBeReturned: urlResponseStub,
            shouldFail: false
        )
        
        let sut = TANetwork(client: clientMock)
        
        var errorReceived: TANetworkError = .unexpectedStatusCode
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: String.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(errorReceived, .decodingFailed)
    }
    
    func test_perform_whenIt_fails_dueTo_requestFailed() async throws {
        // Arrange
        let dummyRequest = TANetworkRequest(
            url: "https://www.google.com",
            method: .get,
            body: nil,
            headers: nil
        )
        let dataStub = DataStub(stub: "stub")
        let dataStubEncoded = try JSONEncoder().encode(dataStub)
        let urlStub = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponseStub = try XCTUnwrap(
            HTTPURLResponse(
                url: urlStub,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        let clientMock = TANetworkClientMock(
            dataToBeReturned: dataStubEncoded,
            responseToBeReturned: urlResponseStub,
            shouldFail: true
        )
        
        let sut = TANetwork(client: clientMock)
        
        var errorReceived: TANetworkError = .unexpectedStatusCode
        
        // Act
        do {
            _ = try await sut.perform(dummyRequest, for: DataStub.self)
        } catch {
            errorReceived = error
        }
        
        // Assert
        XCTAssertEqual(errorReceived, .requestFailed)
    }
}

// MARK: - Test Doubles
struct TANetworkClientMock: TANetworkClient {
    let dataToBeReturned: Data
    let responseToBeReturned: URLResponse
    let shouldFail: Bool
    
    func data(request: URLRequest) async throws -> (Data, URLResponse) {
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
