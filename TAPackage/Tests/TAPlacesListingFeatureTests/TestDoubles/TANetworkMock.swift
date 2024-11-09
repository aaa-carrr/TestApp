//
//  TANetworkMock.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation
import TANetwork
@testable import TAPlacesListingFeature

struct TANetworkMock: TANetworkType {
    let responseToBeReturned: TAPlaceResponse
    let errorToBeReturned: TANetworkError?
    
    func perform<T: Decodable>(_ request: TANetworkRequest, for type: T.Type) async throws(TANetworkError) -> T {
        if let errorToBeReturned {
            throw (errorToBeReturned)
        }
        
        if let response = responseToBeReturned as? T {
            return response
        } else {
            throw(.requestFailed)
        }
    }
}
