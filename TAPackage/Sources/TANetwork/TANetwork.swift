//
//  TANetwork.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

import Foundation

public protocol TANetworkType {
    func perform<T: Decodable, S: Encodable>(_ request: TANetworkRequest<S>, for type: T.Type) async throws(TANetworkError) -> T
}

public struct TANetwork: TANetworkType {
    private let client: TANetworkClient
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public init(
        client: TANetworkClient = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.client = client
        self.decoder = decoder
        self.encoder = encoder
    }
    
    public func perform<T: Decodable, S: Encodable>(_ request: TANetworkRequest<S>, for type: T.Type) async throws(TANetworkError) -> T {
        guard let urlRequest = makeRequestURL(for: request) else {
            throw TANetworkError.invalidRequestFormat
        }
        
        do {
            let (data, response) = try await client.data(request: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TANetworkError.unexpectedResponseType
            }
            
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
    
    private func makeRequestURL<S: Encodable>(for request: TANetworkRequest<S>) -> URLRequest? {
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
