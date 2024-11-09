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
    enum Navigation {
        case openLocation(URL)
    }
    
    // MARK: - Properties
    @Published private(set) var places: [TAPlace] = []
    @Published private(set) var isLoadingPlaces = false
    @Published private(set) var navigation: Navigation?
    
    private let network: TANetworkType
    
    // MARK: - Init
    public init(
        network: TANetworkType = TANetwork()
    ) {
        self.network = network
    }
    
    // MARK: - API
    func placeSelected(_ place: TAPlace) {
        // TODO: Navigate with URL
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
                    name: $0.name ?? "-",
                    latitude: $0.latitude.formatted(),
                    longitude: $0.longitude.formatted()
                )
            }
            self.places = places
        } catch {
            // TODO: Handle error
        }
    }
}
