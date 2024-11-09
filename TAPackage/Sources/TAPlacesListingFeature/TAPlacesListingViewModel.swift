//
//  TAPlacesListingViewModel.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import SwiftUI
import TANetwork

@MainActor
public final class TAPlacesListingViewModel: ObservableObject {
    // MARK: - Navigation
    enum Navigation: Equatable {
        case openLocation(URL)
    }
    
    // MARK: - Properties
    private let network: TANetworkType
    
    // MARK: - Init
    public init(
        network: TANetworkType = TANetwork()
    ) {
        self.network = network
    }
    
    // MARK: - API
    @Published private(set) var places: [TAPlace] = []
    @Published private(set) var isLoadingPlaces = false
    @Published var showMalformedUrlError = false
    @Published var navigation: Navigation?
    
    func placeSelected(_ place: TAPlace) {
        let url: URL?
        if let placeName = place.name {
            url = makeWikipediaPlaceNameDeeplink(for: placeName)
        } else {
            url = makeWikipediaPlaceLocationDeeplink(forPlaceLatitude: place.latitude, longitude: place.longitude)
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
                    id: UUID(),
                    name: $0.name,
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
            self.places = places
        } catch {
            // TODO: Handle error
        }
    }
    
    // MARK: - Privates
    private func makeWikipediaPlaceNameDeeplink(for placeName: String) -> URL? {
        return URL(string: "wikipedia://places?WMFPlaceName=\(placeName)")
    }
    
    private func makeWikipediaPlaceLocationDeeplink(forPlaceLatitude latitude: Double, longitude: Double) -> URL? {
        return URL(string: "wikipedia://places?WMFPlaceLatitude=\(latitude)&WMFPlaceLongitude=\(longitude)")
    }
}
