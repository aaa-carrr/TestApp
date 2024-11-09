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
    
    init(viewModel: TAPlaceSearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Search by Coordinates", isOn: $viewModel.searchByCoordinates)
                }
                
                Section(viewModel.searchByCoordinates ? "Coordinates" : "Place") {
                    if viewModel.searchByCoordinates {
                        TextField("Latitude", text: $viewModel.latitude)
                            .keyboardType(.decimalPad)
                        TextField("Longitude", text: $viewModel.longitude)
                            .keyboardType(.decimalPad)
                    } else {
                        TextField("Name", text: $viewModel.place)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.searchTapped()
                    } label: {
                        Text("Done")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default, value: viewModel.searchByCoordinates)
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