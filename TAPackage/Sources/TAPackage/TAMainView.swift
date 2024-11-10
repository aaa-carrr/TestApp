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
        // I generally prefer dependency injection through init so I did have to dig a bit to find out if
        // doing the below is recommended. Apple provides some info on this page https://developer.apple.com/documentation/swiftui/stateobject.
        // Since this `network` value is already immutable and doesn't contain any state,
        // I feel like passing it through the init like this is fine.
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
