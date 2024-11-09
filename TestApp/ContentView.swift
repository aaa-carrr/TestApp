//
//  ContentView.swift
//  TestApp
//
//  Created by Artur Carneiro on 07/11/2024.
//

import SwiftUI
import TAPlacesListingFeature
import TAPlaceSearchFeature

struct ContentView: View {
    @State var showSearch = false
    var body: some View {
        Button("Search") {
            showSearch = true
        }
        .sheet(isPresented: $showSearch) {
            TAPlaceSearchFeatureView()
        }
//        NavigationView {
//            TAPlacesListingView(viewModel: TAPlacesListingViewModel())
//                .navigationTitle("Places")
//        }
    }
}

#Preview {
    ContentView()
}
