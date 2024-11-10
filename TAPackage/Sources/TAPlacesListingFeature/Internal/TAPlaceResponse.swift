//
//  TAPlaceResponse.swift
//  TAPackage
//
//  Created by Artur Carneiro on 09/11/2024.
//

// I'm keeping this response objects inside the feature module
// so each feature can perform whatever it wants with the endpoint objects they use.
// The more we share across modules, the more we need to take into consideration when making changes.
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
