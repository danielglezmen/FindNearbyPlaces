//
//  FindNearbyPlacesApp.swift
//  FindNearbyPlaces
//
//  Created by Daniel González on 19/1/22.
//

import SwiftUI

@main
struct FindNearbyPlacesApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let favoritesStore = FavoritesStore()
    
    var body: some Scene {
        WindowGroup {
            AutocompleteView()
                .environmentObject(favoritesStore)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background:
                print("App State: Background")
            case .inactive:
                favoritesStore.saveFavorites()
                print("App State: Inactive")
            case .active:
                favoritesStore.loadFavorites()
                print("App State: Active")
            @unknown default:
                print("App State: Unknown")
            }
        }
    }
}
