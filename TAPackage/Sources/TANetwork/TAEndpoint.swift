//
//  TAEndpoint.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

// This protocol can be refactored in the future to include default values such as default headers
public protocol TAEndpoint {
    var request: TANetworkRequest { get }
}
