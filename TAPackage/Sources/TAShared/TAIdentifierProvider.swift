//
//  TAIdentifierProvider.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation

public protocol TAIdentifierProviderType: Sendable {
    var id: UUID { get }
}

public struct TAIdentifierProvider: TAIdentifierProviderType {
    public var id: UUID {
        return UUID()
    }
    
    public init() {}
}
