//
//  AutocompletePlaceRow.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 26/1/22.
//

import SwiftUI

struct AutocompletePlaceRow: View {
    var place: Place
    
    var body: some View {
        NavigationLink {
            PlaceDetailView(place: place, needsAdditionalLoading: true)
        } label: {
            HStack(alignment: .center, spacing: 0) {
                PlaceDescriptionView(place: place)
                Spacer()
                CategoryView(categories: place.categories ?? [])
            }
        }
    }
}

struct AutocompletePlaceRow_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    
    static var previews: some View {
        AutocompletePlaceRow(place: place)
            .previewLayout(.fixed(width: 320, height: 90.0))
    }
}
