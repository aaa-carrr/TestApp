//
//  TAPlaceSearchViewTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import SnapshotTesting
import XCTest
import SwiftUI
@testable import TAPlaceSearchFeature

@MainActor
final class TAPlaceSearchViewTests: XCTestCase {
    let record = false
    
    func test_searchView_initialState() async {
        let viewModel = TAPlaceSearchViewModel(
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(
                placeNameUrlToBeReturned: nil,
                placeLatitudeLongitudeUrlToBeReturned: nil
            ),
            navigation: nil
        )
        
        let sut = TAPlaceSearchView(viewModel: viewModel)
        
        let sutHostingViewController = UIHostingController(rootView: sut)
        sutHostingViewController.view.frame = UIScreen.main.bounds
        
        assertSnapshot(of: sutHostingViewController, as: .image, record: record)
    }
    
    func test_searchView_when_searchingBy_coordindates() async {
        let viewModel = TAPlaceSearchViewModel(
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(
                placeNameUrlToBeReturned: nil,
                placeLatitudeLongitudeUrlToBeReturned: nil
            ),
            navigation: nil
        )
        
        let sut = TAPlaceSearchView(viewModel: viewModel)
        
        let sutHostingViewController = UIHostingController(rootView: sut)
        sutHostingViewController.view.frame = UIScreen.main.bounds
        
        viewModel.searchByCoordinates = true
        
        assertSnapshot(of: sutHostingViewController, as: .image, record: record)
    }
}
