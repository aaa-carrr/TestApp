//
//  TAPlaceSearchViewModelTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation
import XCTest
import TAShared
@testable import TAPlaceSearchFeature

@MainActor
final class TAPlaceSearchViewModelTests: XCTestCase {
    func test_viewModel_when_searchTapped_whileSearchingBy_name() async throws {
        let nameUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceName=HasName"))
        let locationUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceLatitude=32.125123&WMFPlaceLongitude=3.312412"))
        let sut = TAPlaceSearchViewModel(
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(
                placeNameUrlToBeReturned: nameUrlStub,
                placeLatitudeLongitudeUrlToBeReturned: locationUrlStub
            ),
            navigation: nil
        )
        sut.place = "HasName"
        sut.latitude = "32.125123"
        sut.longitude = "3.312412"
        sut.searchByCoordinates = false
        
        XCTAssertNil(sut.navigation)
        
        sut.searchTapped()
        
        XCTAssertEqual(sut.navigation, TAPlaceSearchFeatureView.Navigation.openLocation(nameUrlStub))
    }
    
    func test_viewModel_when_searchTapped_whileSearchingBy_coordinates() async throws {
        let nameUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceName=HasName"))
        let locationUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceLatitude=32.125123&WMFPlaceLongitude=3.312412"))
        let sut = TAPlaceSearchViewModel(
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(
                placeNameUrlToBeReturned: nameUrlStub,
                placeLatitudeLongitudeUrlToBeReturned: locationUrlStub
            ),
            navigation: nil
        )
        sut.place = "HasName"
        sut.latitude = "32.125123"
        sut.longitude = "3.312412"
        sut.searchByCoordinates = true
        
        XCTAssertNil(sut.navigation)
        
        sut.searchTapped()
        
        XCTAssertEqual(sut.navigation, TAPlaceSearchFeatureView.Navigation.openLocation(locationUrlStub))
    }
    
    func test_viewModel_when_searchTapped_fails() async throws {
        let nameUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceName=HasName"))
        let locationUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceLatitude=32.125123&WMFPlaceLongitude=3.312412"))
        let sut = TAPlaceSearchViewModel(
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(
                placeNameUrlToBeReturned: nameUrlStub,
                placeLatitudeLongitudeUrlToBeReturned: locationUrlStub
            ),
            navigation: nil
        )
        sut.place = ""
        sut.latitude = ""
        sut.longitude = ""
        sut.searchByCoordinates = true
        
        XCTAssertNil(sut.navigation)
        XCTAssertFalse(sut.showMalformedUrlError)
        
        sut.searchTapped()
        
        XCTAssertNil(sut.navigation)
        XCTAssertTrue(sut.showMalformedUrlError)
    }
}

// MARK: - Test doubles
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
