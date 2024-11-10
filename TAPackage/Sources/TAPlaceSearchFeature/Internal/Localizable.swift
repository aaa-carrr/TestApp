//
//  Localizable.swift
//  TAPackage
//
//  Created by Artur Carneiro on 10/11/2024.
//

// Some of these strings are repeated in the other feature
// but I'd like to keep the features as separate as possible, sharing as little code as I can,
// including strings. However, if necessary, we can move some of these more generic strings
// to `TAShared`
enum Localizable {
    static let searchByCoordinatesToggle = String(localized: "search-by-coordinates", bundle: .module)
    static let searchByCoordinatesAccessibilityHint = String(localized: "search-by-coordinates-accessibility-hint", bundle: .module)
    static let searchHeaderCoordinates = String(localized: "search-header-coordinates", bundle: .module)
    static let searchHeaderPlace = String(localized: "search-header-place", bundle: .module)
    static let searchCoordinatesLatitude = String(localized: "search-coordinates-latitude", bundle: .module)
    static let searchCoordinatesLongitude = String(localized: "search-coordinates-longitude", bundle: .module)
    static let searchPlaceName = String(localized: "search-place-name", bundle: .module)
    static let searchDone = String(localized: "search-done", bundle: .module)
    static let searchDoneAccessibilityHint = String(localized: "search-done-accessibility-hint", bundle: .module)
    static let searchCancel = String(localized: "search-cancel", bundle: .module)
    static let search = String(localized: "search", bundle: .module)
    static let searchError = String(localized: "search-error", bundle: .module)
    static let searchOk = String(localized: "search-ok", bundle: .module)
    static let searchErrorMessage = String(localized: "search-error-message", bundle: .module)
}
