//
//  TAPlacesEndpoint.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import TANetwork

enum TAPlacesEndpoint {
    case list
}

extension TAPlacesEndpoint: TAEndpoint {
    var request: TANetworkRequest {
        switch self {
        case .list:
            return TANetworkRequest(
                url: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json",
                method: .get,
                body: nil,
                headers: nil
            )
        }
    }
}
