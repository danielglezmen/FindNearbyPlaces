//
//  SnakeCaseJSONDecoder.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 25/1/22.
//

import Foundation

/// JSON decoder subclass to decode JSON with snake_case naming.
class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
