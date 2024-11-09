//
//  IdentifierProviderMock.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation
import TAPlacesListingFeature

struct IdentifierProviderMock: TAIdentifierProviderType {
    let uuid: UUID
    
    var id: UUID {
        return uuid
    }
}
