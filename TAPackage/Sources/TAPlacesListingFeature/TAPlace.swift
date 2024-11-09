//
//  TAPlace.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

import Foundation

struct TAPlace: Equatable, Identifiable {
    var id: UUID
    let name: String?
    let latitude: Double
    let longitude: Double
}
