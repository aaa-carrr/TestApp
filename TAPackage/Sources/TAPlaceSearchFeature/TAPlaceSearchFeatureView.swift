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
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Body
    public var body: some View {
        TAPlaceSearchView(viewModel: TAPlaceSearchViewModel())
    }
}

