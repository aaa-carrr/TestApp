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
        Group {
            if viewModel.isLoadingPlaces && viewModel.places.isEmpty {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.places) { place in
                        TAPlacesListingRowView(
                            place: place,
                            onSelection: { place in
                                viewModel.placeSelected(place)
                            }
                        )
                    }
                }
                .animation(.default, value: viewModel.places)
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
                handle(navigation: newValue)
            }
        }
        .onAppear(perform: {
            if let navigation = viewModel.navigation {
                handle(navigation: navigation)
            }
        })
        .alert("Error", isPresented: $viewModel.showMalformedUrlError) {
            Button(role: .cancel) {
                viewModel.showMalformedUrlError = false
            } label: {
                Text("OK")
            }
        } message: {
            Text("Sorry, we couldn't open this place.")
        }
        .alert("Error", isPresented: $viewModel.showLoadPlacesError) {
            Button(role: .destructive) {
                viewModel.showLoadPlacesError = false
                Task {
                    await viewModel.loadPlaces()
                }
            } label: {
                Text("Retry")
            }
            Button(role: .cancel) {
                viewModel.showLoadPlacesError = false
            } label: {
                Text("OK")
            }
        } message: {
            Text("We encountered an issue while looking for places.")
        }


    }
    
    // MARK: - Helpers
    private func handle(navigation: TAPlacesListingViewModel.Navigation) {
        switch navigation {
        case .openLocation(let url):
            openUrl(url) { _ in
                viewModel.navigation = nil
            }
        }
    }
}

#Preview {
    TAPlacesListingView(viewModel: TAPlacesListingViewModel())
}
