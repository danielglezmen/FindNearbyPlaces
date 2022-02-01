//
//  PlaceDetailStore.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 30/1/22.
//

import Foundation

class PlaceDetailStore {
    
    static func getDetailPlace(from place: Place) async throws -> Place {
        let endpoint = PlacesEndpoint.placeDetail(fsqId: place.fsqId)
        return try await NetworkManager().request(type: Place.self, endpoint: endpoint)
    }
}
