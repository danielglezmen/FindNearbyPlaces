//
//  PlaceSearchRow.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 26/1/22.
//

import SwiftUI

struct PlaceSearchRow: View {
    var place: Place
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: place.photos?.first?
                            .url(for: .custom(width: 120, height: 120)))
                    .frame(width: 60, height: 60)
                    .cornerRadius(10.0)
                PlaceDescriptionView(place: place)
                Spacer()
                VStack(alignment: .trailing) {
                    RatingView(rating: place.rating, font: .body)
                    CategoryView(categories: place.categories ?? [])
                }
            }
        }
    }
}

struct PlaceSearchRowView_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        PlaceSearchRow(place: place)
            .previewLayout(.fixed(width: 320, height: 90.0))
            .environmentObject(FavoritesStore())
    }
}
