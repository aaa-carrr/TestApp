//
//  TANetworkClient.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

import Foundation

public protocol TANetworkClient: Sendable {
    func data(request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: TANetworkClient {
    public func data(request: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: request)
    }
}
