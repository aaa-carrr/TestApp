//
//  TANetworkRequest.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

public struct TANetworkRequest<T: Encodable> {
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    public let url: String
    public let method: TANetworkRequest.HTTPMethod
    public let body: T
    public let headers: [String: String]?
    
    public init(
        url: String,
        method: TANetworkRequest.HTTPMethod,
        body: T,
        headers: [String : String]?
    ) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
    }
}
