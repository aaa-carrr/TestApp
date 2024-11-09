//
//  TAPlacesListingViewModelTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import XCTest
import TANetwork
@testable import TAPlacesListingFeature

@MainActor
final class TAPlacesListingViewModelTests: XCTestCase {
    func test_viewModel_when_loadPlaces_succeeds() async throws {
        let places = [
            TAPlaceModel(name: "Amsterdam", latitude: 31.5215, longitude: 4.412312),
            TAPlaceModel(name: "Copenhagen", latitude: 12.5215, longitude: 81.412312),
            TAPlaceModel(name: nil, latitude: 43.12354, longitude: 12.3423412),
        ]
        let uuid = try XCTUnwrap(UUID(uuidString: "3079EAD7-21D2-4E26-B941-76982E276630"))
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: places),
            errorToBeReturned: nil
        )
        let sut = TAPlacesListingViewModel(
            network: networkMock,
            identifierProvider: IdentifierProviderMock(uuid: uuid),
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nil, placeLatitudeLongitudeUrlToBeReturned: nil),
            navigation: nil
        )
        let expectedPlaces = [
            TAPlace(id: uuid, name: "Amsterdam", latitude: 31.5215, longitude: 4.412312),
            TAPlace(id: uuid, name: "Copenhagen", latitude: 12.5215, longitude: 81.412312),
            TAPlace(id: uuid, name: nil, latitude: 43.12354, longitude: 12.3423412),
        ]
        
        XCTAssertTrue(sut.places.isEmpty)
        
        await sut.loadPlaces()
        
        XCTAssertEqual(sut.places, expectedPlaces)
        XCTAssertFalse(sut.showLoadPlacesError)
    }
    
    func test_viewModel_when_loadPlaces_fails() async throws {
        let places = [
            TAPlaceModel(name: "Amsterdam", latitude: 31.5215, longitude: 4.412312),
            TAPlaceModel(name: "Copenhagen", latitude: 12.5215, longitude: 81.412312),
            TAPlaceModel(name: nil, latitude: 43.12354, longitude: 12.3423412),
        ]
        let uuid = try XCTUnwrap(UUID(uuidString: "3079EAD7-21D2-4E26-B941-76982E276630"))
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: places),
            errorToBeReturned: .decodingFailed
        )
        let sut = TAPlacesListingViewModel(
            network: networkMock,
            identifierProvider: IdentifierProviderMock(uuid: uuid),
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nil, placeLatitudeLongitudeUrlToBeReturned: nil),
            navigation: nil
        )
        
        XCTAssertTrue(sut.places.isEmpty)
        
        await sut.loadPlaces()
        
        XCTAssertTrue(sut.places.isEmpty)
        XCTAssertTrue(sut.showLoadPlacesError)
    }
    
    func test_viewModel_when_placeSelected_opensUrl_with_success_using_placeName() async throws {
        let stubPlace = TAPlace(
            id: UUID(),
            name: "HasName",
            latitude: 32.125123,
            longitude: 3.312412
        )
        let nameUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceName=HasName"))
        let locationUrlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceLatitude=32.125123&WMFPlaceLongitude=3.312412"))
        let uuid = try XCTUnwrap(UUID(uuidString: "3079EAD7-21D2-4E26-B941-76982E276630"))
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: []),
            errorToBeReturned: nil
        )
        let sut = TAPlacesListingViewModel(
            network: networkMock,
            identifierProvider: IdentifierProviderMock(uuid: uuid),
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nameUrlStub, placeLatitudeLongitudeUrlToBeReturned: locationUrlStub),
            navigation: nil
        )
        
        XCTAssertNil(sut.navigation)
        
        sut.placeSelected(stubPlace)

        XCTAssertEqual(sut.navigation, TAPlacesListingViewModel.Navigation.openLocation(nameUrlStub))
    }
    
    func test_viewModel_when_placeSelected_opensUrl_with_success_using_latitudeAndLongitude() async throws {
        let stubPlace = TAPlace(
            id: UUID(),
            name: nil,
            latitude: 32.125123,
            longitude: 3.312412
        )
        let urlStub = try XCTUnwrap(URL(string: "wikipedia://places?WMFPlaceLatitude=32.125123&WMFPlaceLongitude=3.312412"))
        let uuid = try XCTUnwrap(UUID(uuidString: "3079EAD7-21D2-4E26-B941-76982E276630"))
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: []),
            errorToBeReturned: nil
        )
        let sut = TAPlacesListingViewModel(
            network: networkMock,
            identifierProvider: IdentifierProviderMock(uuid: uuid),
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nil, placeLatitudeLongitudeUrlToBeReturned: urlStub),
            navigation: nil
        )
        
        XCTAssertNil(sut.navigation)
        
        sut.placeSelected(stubPlace)

        XCTAssertEqual(sut.navigation, TAPlacesListingViewModel.Navigation.openLocation(urlStub))
    }
    
    func test_viewModel_when_placeSelected_opensUrl_with_failure() async throws {
        let stubPlace = TAPlace(
            id: UUID(),
            name: nil,
            latitude: 32.125123,
            longitude: 3.312412
        )
        let uuid = try XCTUnwrap(UUID(uuidString: "3079EAD7-21D2-4E26-B941-76982E276630"))
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: []),
            errorToBeReturned: nil
        )
        let sut = TAPlacesListingViewModel(
            network: networkMock,
            identifierProvider: IdentifierProviderMock(uuid: uuid),
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nil, placeLatitudeLongitudeUrlToBeReturned: nil),
            navigation: nil
        )
        
        XCTAssertNil(sut.navigation)
        XCTAssertFalse(sut.showMalformedUrlError)
        
        sut.placeSelected(stubPlace)

        XCTAssertNil(sut.navigation)
        XCTAssertTrue(sut.showMalformedUrlError)
    }
}
