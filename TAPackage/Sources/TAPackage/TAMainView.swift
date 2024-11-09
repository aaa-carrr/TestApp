import SwiftUI
import TAPlacesListingFeature
import TAPlaceSearchFeature

public struct TAMainView: View {
    // MARK: - Properties
    @StateObject private var listingViewModel = TAPlacesListingViewModel()
    @State private var showSearch = false
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Body
    public var body: some View {
        NavigationView {
            TAPlacesListingView(viewModel: listingViewModel)
                .navigationTitle("Places")
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
