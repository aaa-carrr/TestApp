//
//  TANetwork.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

import Foundation

public protocol TANetworkType: Sendable {
    func perform<T: Decodable>(_ request: TANetworkRequest, for type: T.Type) async throws(TANetworkError) -> T
}

public struct TANetwork: TANetworkType {
    private let client: TANetworkClient
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // I prefer passing in a decoder and encoder in case a specific feature/module in the app
    // needs a super custom decoding strategy. Having only one hardcoded decoder makes it harder for us
    // to make these kind of changes in the future
    public init(
        client: TANetworkClient = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.client = client
        self.decoder = decoder
        self.encoder = encoder
    }
    
    public func perform<T: Decodable>(_ request: TANetworkRequest, for type: T.Type) async throws(TANetworkError) -> T {
        // This currently doesn't handle retrying or any kind of logging but it's something
        // that could be added if necessary.
        guard let urlRequest = makeRequestURL(for: request) else {
            throw TANetworkError.invalidRequestFormat
        }
        
        do {
            let (data, response) = try await client.data(request: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TANetworkError.unexpectedResponseType
            }
            
            // The range of accepted status codes could be included inside `TANetworkRequest`
            guard 200...299 ~= httpResponse.statusCode else {
                throw TANetworkError.unexpectedStatusCode
            }
            
            do {
                return try decoder.decode(type, from: data)
            } catch {
                throw TANetworkError.decodingFailed
            }
        } catch let error as TANetworkError {
            throw error
        } catch {
            throw TANetworkError.requestFailed
        }
    }
    
    private func makeRequestURL(for request: TANetworkRequest) -> URLRequest? {
        // If necessary, I would add proper errors to be thrown here to avoid
        // returning `nil` to all possible errors that can happen here.
        guard let url = URL(string: request.url) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        if let body = request.body {
            guard let encondedBody = try? encoder.encode(body) else {
                return nil
            }
            
            urlRequest.httpBody = encondedBody
        }
        
        return urlRequest
    }
}
