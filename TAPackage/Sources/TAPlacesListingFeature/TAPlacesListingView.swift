//
//  TAPlacesListingView.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

import SwiftUI

public struct TAPlacesListingView: View {
    @ObservedObject var viewModel: TAPlacesListingViewModel
    @Environment(\.openURL) private var openUrl
    
    public init(viewModel: TAPlacesListingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            if viewModel.isLoadingPlaces && viewModel.places.isEmpty {
                ProgressView()
                    .navigationTitle("Places")
            } else {
                List {
                    ForEach(viewModel.places) { place in
                        TAPlacesListingRowView(
                            place: place,
                            onSelection: { place in
                                self.viewModel.placeSelected(place)
                            }
                        )
                    }
                }
                .animation(.default, value: viewModel.places)
                .navigationTitle("Places")
                .refreshable {
                    await viewModel.loadPlaces()
                }
            }
        }
        .task {
            await viewModel.loadPlaces()
        }
        .onChange(of: viewModel.navigation) { newValue in
            if let newValue {
                switch newValue {
                case .openLocation(let url):
                    openUrl(url) { _ in
                        viewModel.navigation = nil
                    }
                }
            }
        }
    }
}

#Preview {
    TAPlacesListingView(viewModel: TAPlacesListingViewModel())
}
