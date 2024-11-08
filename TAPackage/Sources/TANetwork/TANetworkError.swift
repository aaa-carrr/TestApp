//
//  TANetworkError.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

public enum TANetworkError: Error, Equatable {
    case invalidRequestFormat
    case requestFailed
    case decodingFailed
    case unexpectedResponseType
    case unexpectedStatusCode
}
