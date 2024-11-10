//
//  TAPlacesListingView.swift
//  TAPackage
//
//  Created by Artur Carneiro on 08/11/2024.
//

import SwiftUI

public struct TAPlacesListingView: View {
    @ObservedObject var viewModel: TAPlacesListingViewModel
    // Ideally I would be able to mock this action to write unit tests for the view to guarantee a tap of a button
    // attemps to opens an URL but this kind of test might be better done using UI tests in SwiftUI's case.
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
        .alert(Localizable.listingError, isPresented: $viewModel.showMalformedUrlError) {
            Button(role: .cancel) {
                viewModel.showMalformedUrlError = false
            } label: {
                Text(Localizable.listingOk)
            }
        } message: {
            Text(Localizable.listingOpenErrorMessage)
        }
        .alert(Localizable.listingError, isPresented: $viewModel.showLoadPlacesError) {
            Button(role: .destructive) {
                viewModel.showLoadPlacesError = false
                Task {
                    await viewModel.loadPlaces()
                }
            } label: {
                Text(Localizable.listingErrorRetry)
            }
            Button(role: .cancel) {
                viewModel.showLoadPlacesError = false
            } label: {
                Text(Localizable.listingOk)
            }
        } message: {
            Text(Localizable.listingLoadErrorMessage)
        }
        
        // I've used alerts to display errors but they are horrible to run snapshot tests on.
        // I would in the future write smaller views to handle the presentation of errors
        // so we can properly test these views.
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
