//
//  PlaceSearchView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 26/1/22.
//

import SwiftUI

struct PlaceSearchView: View {
    var query: String
    @StateObject private var store = PlaceStore()
    @State private var isShowingMap = false
    
    var body: some View {
        ZStack {
            List(store.places) { place in
                NavigationLink {
                    PlaceDetailView(place: place)
                } label: {
                    PlaceSearchRow(place: place)
                }
            }
            .task {
                if store.places.isEmpty {
                    await searchPlaces()                    
                }
            }
            .refreshable {
                print("refresh.....")
                await searchPlaces()
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(query)
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingMap.toggle()
                    } label: {
                        Image(systemName: isShowingMap ? "list.bullet" : "map")
                    }
                }
            }
            if isShowingMap {
                MapView(presentation: .places(places: store.places))
            }
        }
    }
    
    private func searchPlaces() async {
        do {
            try await store.searchPlaces(query)
        } catch {
            print(error)
        }
    }
}

struct SearchPlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaceSearchView(query: "Italian")
                .preferredColorScheme(.dark)
        }
        .environmentObject(FavoritesStore())
    }
}
