//
//  PlaceDescriptionView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 28/1/22.
//

import SwiftUI

struct PlaceDescriptionView: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(place.name ?? "")
                FavoriteButton(id: place.id)
            }
            Text(place.distanceDescription)
                .font(.footnote)
            Text(place.location?.locality ?? "")
                .font(.caption2)
        }
    }
}

struct PlaceDescriptionView_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        PlaceDescriptionView(place: place)
            .previewLayout(.fixed(width: 320, height: 90.0))
            .environmentObject(FavoritesStore())
    }
}
