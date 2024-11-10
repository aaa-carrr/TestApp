//
//  TAPlaceSearchViewModel.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation
import TAShared

@MainActor
final class TAPlaceSearchViewModel: ObservableObject {    
    // MARK: - Properties
    private let wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryType
    
    // MARK: - Init
    init(
        wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryType = TAWikipediaDeeplinkFactory(),
        navigation: TAPlaceSearchFeatureView.Navigation? = nil
    ) {
        self.wikipediaDeeplinkFactory = wikipediaDeeplinkFactory
        self.navigation = navigation
    }
    
    // MARK: - API
    @Published var searchByCoordinates = false
    @Published var latitude = ""
    @Published var longitude = ""
    @Published var place = ""
    @Published var showMalformedUrlError = false
    @Published var navigation: TAPlaceSearchFeatureView.Navigation?
    
    func searchTapped() {
        let url: URL?
        
        if searchByCoordinates {
            if let latitudeDouble = Double(formattedLatitude),
               let longitudeDouble = Double(formattedLongitude) {
                url = wikipediaDeeplinkFactory.makePlaceLocationDeeplink(
                    forPlaceLatitude: latitudeDouble,
                    longitude: longitudeDouble
                )
            } else {
                showMalformedUrlError = true
                return
            }
        } else {
            url = wikipediaDeeplinkFactory.makePlaceNameDeeplink(for: formattedPlaceName)
        }
        
        guard let url else {
            showMalformedUrlError = true
            return
        }
        
        navigation = .openLocation(url)
    }
    
    // MARK: - Privates
    // I think that all of the formatting done below can be done better, either by using a proper formatter
    // or writing more code to catch more exceptions but for now this covers the main issues I found:
    // * Whitespace added at the end of a word due to autocorrect or by picking a suggestion in the keyboard
    // * Locales in which the decimal separator is a comma instead of a point
    private var formattedPlaceName: String {
        let placeArray = Array(place)
        var mutablePlaceArray = Array(place)
        var index = mutablePlaceArray.count - 1
        
        while index >= 0 {
            let characterAtIndex = placeArray[index]
            if characterAtIndex.isWhitespace {
                mutablePlaceArray.remove(at: index)
                index -= 1
            } else {
                break
            }
        }
        
        return String(mutablePlaceArray)
    }
    
    private var formattedLatitude: String {
        return latitude.replacingOccurrences(of: ",", with: ".")
    }
    
    private var formattedLongitude: String {
        return longitude.replacingOccurrences(of: ",", with: ".")
    }
}
