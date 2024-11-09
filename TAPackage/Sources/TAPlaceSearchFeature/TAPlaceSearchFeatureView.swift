//
//  TAPlaceSearchFeatureView.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import SwiftUI

public struct TAPlaceSearchFeatureView: View {
    // MARK: - Navigation
    enum Navigation: Equatable {
        case openLocation(URL)
    }
    
    // MARK: - Properties
    @ObservedObject private var viewModel: TAPlaceSearchViewModel
    
    // MARK: - Init
    public init() {
        self.viewModel = TAPlaceSearchViewModel()
    }
    
    init(
        viewModel: TAPlaceSearchViewModel
    ) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    public var body: some View {
        TAPlaceSearchView(viewModel: viewModel)
    }
}
