//
//  TAWikipediaDeeplinkFactoryMock.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation
import TAShared

struct TAWikipediaDeeplinkFactoryMock: TAWikipediaDeeplinkFactoryType {
    let placeNameUrlToBeReturned: URL?
    let placeLatitudeLongitudeUrlToBeReturned: URL?
    
    func makePlaceNameDeeplink(for placeName: String) -> URL? {
        return placeNameUrlToBeReturned
    }
    
    func makePlaceLocationDeeplink(forPlaceLatitude latitude: Double, longitude: Double) -> URL? {
        return placeLatitudeLongitudeUrlToBeReturned
    }
    
    
}
