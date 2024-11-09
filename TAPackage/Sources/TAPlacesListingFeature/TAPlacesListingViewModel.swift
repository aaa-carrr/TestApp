//
//  TAPlacesListingViewModel.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation
import TANetwork
import TAShared

@MainActor
public final class TAPlacesListingViewModel: ObservableObject {
    // MARK: - Navigation
    public enum Navigation: Equatable {
        case openLocation(URL)
    }
    
    // MARK: - Properties
    private let network: TANetworkType
    private let identifierProvider: TAIdentifierProviderType
    private let wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryType
    
    // MARK: - Init
    public init(
        network: TANetworkType = TANetwork(),
        identifierProvider: TAIdentifierProviderType = TAIdentifierProvider(),
        wikipediaDeeplinkFactory: TAWikipediaDeeplinkFactoryType = TAWikipediaDeeplinkFactory(),
        navigation: Navigation? = nil
    ) {
        self.network = network
        self.navigation = navigation
        self.identifierProvider = identifierProvider
        self.wikipediaDeeplinkFactory = wikipediaDeeplinkFactory
    }
    
    // MARK: - API
    @Published private(set) var places: [TAPlace] = []
    @Published var isLoadingPlaces = false
    @Published var showMalformedUrlError = false
    @Published var showLoadPlacesError = false
    @Published var navigation: Navigation?
    
    func placeSelected(_ place: TAPlace) {
        let url: URL?
        if let placeName = place.name {
            url = wikipediaDeeplinkFactory.makePlaceNameDeeplink(for: placeName)
        } else {
            url = wikipediaDeeplinkFactory.makePlaceLocationDeeplink(forPlaceLatitude: place.latitude, longitude: place.longitude)
        }
        
        guard let url else {
            showMalformedUrlError = true
            return
        }
        
        navigation = .openLocation(url)
    }
    
    func loadPlaces() async {
        isLoadingPlaces = true
        defer { isLoadingPlaces = false }
        let request = TAPlacesEndpoint.list.request
        do {
            let response = try await network.perform(request, for: TAPlaceResponse.self)
            let places = response.locations.map {
                TAPlace(
                    id: identifierProvider.id,
                    name: $0.name,
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
            self.places = places
        } catch {
            showLoadPlacesError = true
        }
    }
}
