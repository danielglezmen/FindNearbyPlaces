//
//  FavoriteButton.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 31/1/22.
//

import SwiftUI

struct FavoriteButton: View {
    let id: String
    @EnvironmentObject private var favoritesStore: FavoritesStore
    
    var body: some View {
        Button {
            favoritesStore.favorites.toggleFavorite(id: id)
        } label: {
            Image(systemName:
                    favoritesStore.favorites
                    .isFavorite(id: id) ? "star.fill" : "star")
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(id: "fakeid")
            .environmentObject(FavoritesStore())
    }
}
