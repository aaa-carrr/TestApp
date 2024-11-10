//
//  TAPlacesListingRowView.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import SwiftUI

struct TAPlacesListingRowView: View {
    let place: TAPlace
    let onSelection: ((TAPlace) -> Void)
    
    var body: some View {
        HStack {
            VStack(spacing: 12) {
                HStack {
                    Text(place.name ?? "-")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                HStack {
                    Image(systemName: "location")
                        .foregroundStyle(.secondary)
                    Text(place.latitude.formatted())
                    Text(place.longitude.formatted())
                    Spacer()
                }
            }
            Spacer()
            Button {
                onSelection(place)
            } label: {
                Image(systemName: "link")
                    .foregroundStyle(.blue)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(place.name ?? Localizable.listingUnknownPlace)
        .accessibilityValue(Localizable.listingLatitudeLongitude(latitude: place.latitude, longitude: place.longitude))
        .accessibilityHint(Localizable.listingRedirectAccessibilityHint)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    TAPlacesListingRowView(
        place: TAPlace(id: UUID(), name: "Amsterdam", latitude: 12.4331231, longitude: 34.65234123),
        onSelection: { place in
            print(place.name ?? "-")
        }
    )
}
