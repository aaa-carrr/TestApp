import SwiftUI
import TAPlacesListingFeature
import TAPlaceSearchFeature
import TANetwork
import TAShared

public struct TAMainView: View {
    // MARK: - Properties
    @StateObject private var listingViewModel: TAPlacesListingViewModel
    @State private var showSearch = false
    
    // MARK: - Init
    public init(network: TANetworkType = TANetwork()) {
        _listingViewModel = StateObject(wrappedValue: TAPlacesListingViewModel(network: network))
    }
    
    // MARK: - Body
    public var body: some View {
        NavigationView {
            TAPlacesListingView(viewModel: listingViewModel)
                .navigationTitle(Localizable.mainPlaceTitle)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSearch = true
                        } label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                        }
                    }
                }
                .sheet(isPresented: $showSearch) {
                    TAPlaceSearchFeatureView()
                }
        }
    }
}
