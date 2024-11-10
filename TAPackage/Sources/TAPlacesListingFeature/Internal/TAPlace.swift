//
//  TAPlace.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation

struct TAPlace: Equatable, Identifiable {
    // Ideally, this `id` would either come from backend or we would create a better
    // approach to prevent creating UUIDs without too much control.
    // As far as I understand, the more stable the `id` is, the less unncessary redraws
    // SwiftUI performs.
    var id: UUID
    let name: String?
    let latitude: Double
    let longitude: Double
}
