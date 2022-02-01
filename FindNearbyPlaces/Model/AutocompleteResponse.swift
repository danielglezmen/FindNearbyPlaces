//
//  AutocompleteResponse.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 26/1/22.
//

import Foundation

struct AutocompleteResponse: Codable {
    var results: [Result]
}

extension AutocompleteResponse {
    struct Result: Codable, Identifiable {
        var id: UUID { UUID() }
        var type: ResultType
        var text: Text
        var place: Place?
        var search: Search?
    }
}

extension AutocompleteResponse.Result {
    enum ResultType: String, Codable {
        case place
        case search
    }
    
    struct Text: Codable {
        var primary: String
        var secondary: String
    }
    
    struct Search: Codable {
        var query: String
    }
}
