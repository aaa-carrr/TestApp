//
//  TAPlacesListingViewTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

import SnapshotTesting
import XCTest
import SwiftUI
@testable import TAPlacesListingFeature

@MainActor
final class TAPlacesListingViewTests: XCTestCase {
    let record = false
    
    func test_listinView_when_loadingWithEmptyPlaces() async throws {
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: []),
            errorToBeReturned: nil
        )
        let viewModel = TAPlacesListingViewModel(
            network: networkMock,
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nil, placeLatitudeLongitudeUrlToBeReturned: nil),
            navigation: nil
        )
        
        let sut = TAPlacesListingView(viewModel: viewModel)
        
        let sutHostingController = UIHostingController(rootView: sut)
        sutHostingController.view.frame = UIScreen.main.bounds
        
        viewModel.isLoadingPlaces = true
        
        assertSnapshot(of: sutHostingController, as: .image, record: record)
    }
    
    func test_listinView_when_loadingWithPlaces() async throws {
        let places = [
            TAPlaceModel(name: "Amsterdam", latitude: 31.5215, longitude: 4.412312),
            TAPlaceModel(name: "Copenhagen", latitude: 12.5215, longitude: 81.412312),
            TAPlaceModel(name: nil, latitude: 43.12354, longitude: 12.3423412),
        ]
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: places),
            errorToBeReturned: nil
        )
        let viewModel = TAPlacesListingViewModel(
            network: networkMock,
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nil, placeLatitudeLongitudeUrlToBeReturned: nil),
            navigation: nil
        )
        
        let sut = TAPlacesListingView(viewModel: viewModel)
        
        let sutHostingController = UIHostingController(rootView: sut)
        sutHostingController.view.frame = UIScreen.main.bounds
        
        await viewModel.loadPlaces()
        viewModel.isLoadingPlaces = true
        
        assertSnapshot(of: sutHostingController, as: .image, record: record)
    }
    
    func test_listinView_when_placesHaveLoaded() async throws {
        let places = [
            TAPlaceModel(name: "Copenhagen", latitude: 31.5215, longitude: 4.412312),
            TAPlaceModel(name: "Amsterdam", latitude: 12.5215, longitude: 81.412312),
            TAPlaceModel(name: nil, latitude: 43.12354, longitude: 12.3423412),
        ]
        let networkMock = TANetworkMock(
            responseToBeReturned: TAPlaceResponse(locations: places),
            errorToBeReturned: nil
        )
        let viewModel = TAPlacesListingViewModel(
            network: networkMock,
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(placeNameUrlToBeReturned: nil, placeLatitudeLongitudeUrlToBeReturned: nil),
            navigation: nil
        )
        
        let sut = TAPlacesListingView(viewModel: viewModel)
        
        let sutHostingController = UIHostingController(rootView: sut)
        sutHostingController.view.frame = UIScreen.main.bounds
        
        await viewModel.loadPlaces()
        
        assertSnapshot(of: sutHostingController, as: .image, record: record)
    }
}
