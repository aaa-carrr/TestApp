//
//  TAPlaceSearchView.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import SwiftUI

struct TAPlaceSearchView: View {
    @ObservedObject private var viewModel: TAPlaceSearchViewModel
    @Environment(\.openURL) private var openUrl
    @Environment(\.dismiss) private var dismiss
    
    private var isDoneButtonDisabled: Bool {
        if viewModel.searchByCoordinates {
            return (viewModel.latitude.isEmpty || viewModel.longitude.isEmpty)
        } else {
            return viewModel.place.isEmpty
        }
    }
    
    init(viewModel: TAPlaceSearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(Localizable.searchByCoordinatesToggle, isOn: $viewModel.searchByCoordinates)
                        .accessibilityHint(Localizable.searchByCoordinatesAccessibilityHint)
                }
                
                Section(viewModel.searchByCoordinates ? Localizable.searchHeaderCoordinates : Localizable.searchHeaderPlace) {
                    if viewModel.searchByCoordinates {
                        TextField(Localizable.searchCoordinatesLatitude, text: $viewModel.latitude)
                            .keyboardType(.decimalPad)
                        TextField(Localizable.searchCoordinatesLongitude, text: $viewModel.longitude)
                            .keyboardType(.decimalPad)
                    } else {
                        TextField(Localizable.searchPlaceName, text: $viewModel.place)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.searchTapped()
                    } label: {
                        Text(Localizable.searchDone)
                    }
                    .disabled(isDoneButtonDisabled)
                    .accessibilityHint(Localizable.searchDoneAccessibilityHint)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(Localizable.searchCancel)
                    }
                }
            }
            .navigationTitle(Localizable.search)
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default, value: viewModel.searchByCoordinates)
        }
        .onChange(of: viewModel.navigation) { newValue in
            if let newValue {
                handle(navigation: newValue)
            }
        } // I'm adding both `onChange` and `onAppear` since on iOS 15 we can't provide an initial value to `onChange`
        .onAppear(perform: {
            if let navigation = viewModel.navigation {
                handle(navigation: navigation)
            }
        })
        .alert(Localizable.searchError, isPresented: $viewModel.showMalformedUrlError) {
            Button(role: .cancel) {
                viewModel.showMalformedUrlError = false
            } label: {
                Text(Localizable.searchOk)
            }
        } message: {
            Text(Localizable.searchErrorMessage)
        }
    }
    
    // MARK: - Helpers
    private func handle(navigation: TAPlaceSearchFeatureView.Navigation) {
        switch navigation {
        case .openLocation(let url):
            openUrl(url) { _ in
                viewModel.navigation = nil
            }
        }
    }
}

#Preview {
    VStack {
        Text("")
            .sheet(isPresented: .constant(true)) {
                TAPlaceSearchView(viewModel: TAPlaceSearchViewModel())
            }
    }
}
