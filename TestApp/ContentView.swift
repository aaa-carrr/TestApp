//
//  ContentView.swift
//  TestApp
//
//  Created by Artur Carneiro on 07/11/2024.
//

import SwiftUI
import TAPlacesListingFeature

struct ContentView: View {
    var body: some View {
        NavigationView {
            TAPlacesListingView(viewModel: TAPlacesListingViewModel())
                .navigationTitle("Places")
        }
    }
}

#Preview {
    ContentView()
}
