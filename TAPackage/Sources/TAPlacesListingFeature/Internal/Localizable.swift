//
//  Localizable.swift
//  TAPackage
//
//  Created by Artur Carneiro on 10/11/2024.
//

enum Localizable {
    static let listingError = String(localized: "listing-error", bundle: .module)
    static let listingOk = String(localized: "listing-ok", bundle: .module)
    static let listingOpenErrorMessage = String(localized: "listing-open-error-message", bundle: .module)
    static let listingErrorRetry = String(localized: "listing-error-retry", bundle: .module)
    static let listingLoadErrorMessage = String(localized: "listing-load-error-message", bundle: .module)
    static let listingUnknownPlace = String(localized: "listing-unknown-place", bundle: .module)
    static func listingLatitudeLongitude(latitude: Double, longitude: Double) -> String {
        return String(format: String(localized: "listing-latitude-%lf-longitude-%lf", bundle: .module), latitude, longitude)
    }
    static let listingRedirectAccessibilityHint = String(localized: "listing-redirect-accessibility-hint", bundle: .module)
}
