//
//  PlaceStore.swift
//  FindNearbyPlaces
//
//  Created by Daniel González on 19/1/22.
//

import Foundation
import Combine
import MapKit

@MainActor
class PlaceStore: ObservableObject {
    
    @Published var places = [Place]()
    
    /// Async request to the search place API.
    /// - Parameter text: The text to search.
    func searchPlaces(_ text: String) async throws {
        let endpoint = PlacesEndpoint.placeSearch(query: text,
                                                  categories: [],
                                                  location: LocationManager.shared.currentLocation.stringDescription)
        let response = try await NetworkManager().request(type: SearchPlaceResponse.self, endpoint: endpoint)
        places = response.results
        print("Search places request end with \(response.results.count) places")
    }
}
