//
//  SearchPlaceResponse.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 25/1/22.
//

import Foundation

struct SearchPlaceResponse: Codable {
    var results: [Place]
    var context: Context?
}

extension SearchPlaceResponse {
    struct Context: Codable {
        var geoBounds: GeoBounds?
    }
}

extension SearchPlaceResponse.Context {
    struct GeoBounds: Codable {
        var circle: Circle?
    }
}

extension SearchPlaceResponse.Context.GeoBounds {
    struct Circle: Codable {
        var center: Center?
        var radius: Int
    }
}

extension SearchPlaceResponse.Context.GeoBounds.Circle {
    struct Center: Codable {
        var latitude: Double
        var longitude: Double
    }
}
