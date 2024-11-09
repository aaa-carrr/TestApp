//
//  TAPlaceSearchFeatureViewTests.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import SnapshotTesting
import XCTest
import SwiftUI
@testable import TAPlaceSearchFeature

@MainActor
final class TAPlaceSearchFeatureViewTests: XCTestCase {
    let record = false
    
    func test_featureView_initialState() async {
        let viewModel = TAPlaceSearchViewModel(
            wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryMock(
                placeNameUrlToBeReturned: nil,
                placeLatitudeLongitudeUrlToBeReturned: nil
            ),
            navigation: nil
        )
        
        let sut = TAPlaceSearchFeatureView(viewModel: viewModel)
        
        let sutHostingViewController = UIHostingController(rootView: sut)
        sutHostingViewController.view.frame = UIScreen.main.bounds
        
        assertSnapshot(of: sutHostingViewController, as: .image, record: record)
    }
}
