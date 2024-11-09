//
//  TAPlaceResponse.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

struct TAPlaceResponse: Decodable {
    let locations: [TAPlaceModel]
}

struct TAPlaceModel: Decodable {
    let name: String?
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
