//
//  TANetworkRequest.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

public struct TANetworkRequest {
    public let url: String
    public let method: TAHTTPMethod
    public let body: Encodable?
    public let headers: [String: String]?
    
    public init(
        url: String,
        method: TAHTTPMethod,
        body: Encodable?,
        headers: [String : String]?
    ) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
    }
}
