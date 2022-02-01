//
//  FavoritesStore.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 1/2/22.
//

import Foundation

class FavoritesStore: ObservableObject {

    @Published var favorites = Favorites(ids: [])
    
    /// Load favorites from disk.
    func loadFavorites() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "myFile", relativeTo: directoryURL)
        guard let data = try? Data(contentsOf: fileURL) else {
            favorites = Favorites(ids: [])
            return
        }
        do {
            favorites = try JSONDecoder().decode(Favorites.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Save favorites to disk.
    func saveFavorites() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "myFile", relativeTo: directoryURL)
        do {
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
