//
//  Favorites.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 31/1/22.
//

import Foundation

struct Favorites: Codable {
    var ids: Set<String>
    
    func isFavorite(id: String) -> Bool {
        ids.contains { $0 == id }
    }
    
    mutating func toggleFavorite(id: String) {
        if isFavorite(id: id) {
            ids = ids.filter { $0 != id }
        } else {
            ids.insert(id)
        }
    }
}
