//
//  TAWikipediaDeeplinkFactoryTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import XCTest
@testable import TAShared

final class TAWikipediaDeeplinkFactoryTests: XCTestCase {
    func test_factory_makePlaceNameDeeplink_with_placeName() throws {
        let validPlaceName = "Amsterdam"
        let expectedUrl = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceName=Amsterdam"))
        let sut = TAWikipediaDeeplinkFactory()
        
        let url = sut.makePlaceNameDeeplink(for: validPlaceName)
        
        XCTAssertEqual(url, expectedUrl)
    }
    
    func test_factory_makePlaceNameDeeplink_with_placeLatitudeAndLongitude() throws {
        let longitude = 31.41231
        let latitude = 5.125123
        let expectedUrl = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceLatitude=5.125123&WMFPlaceLongitude=31.41231"))
        let sut = TAWikipediaDeeplinkFactory()
        
        let url = sut.makePlaceLocationDeeplink(forPlaceLatitude: latitude, longitude: longitude)
        
        XCTAssertEqual(url, expectedUrl)
    }
}
