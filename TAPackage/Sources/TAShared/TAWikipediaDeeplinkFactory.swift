//
//  TAWikipediaDeeplinkFactory.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation

public protocol TAWikipediaDeeplinkFactoryType: Sendable {
    func makePlaceNameDeeplink(for placeName: String) -> URL?
    func makePlaceLocationDeeplink(forPlaceLatitude latitude: Double, longitude: Double) -> URL?
}

public struct TAWikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryType {
    public func makePlaceNameDeeplink(for placeName: String) -> URL? {
        return URL(string: "wikipedia://places?WMFPlaceName=\(placeName)")
    }
    
    public func makePlaceLocationDeeplink(forPlaceLatitude latitude: Double, longitude: Double) -> URL? {
        return URL(string: "wikipedia://places?WMFPlaceLatitude=\(latitude)&WMFPlaceLongitude=\(longitude)")
    }
    
    public init() {}
}
