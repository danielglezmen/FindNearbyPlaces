//
//  PlaceDetailBodyView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 29/1/22.
//

import SwiftUI

struct PlaceDetailBodyView: View {
    let place: Place
    let namespace: Namespace.ID
    @Binding var isShowingModal: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(place.name ?? "")
                    .font(.title)
                FavoriteButton(id: place.id)
                    .font(.title)
                Spacer()
                RatingView(rating: place.rating, font: .title)
            }
            Divider()
            HStack {
                CategoryView(categories: place.categories ?? [], size: .size120)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    ForEach(place.categories ?? []) { category in
                        Text(category.name)
                    }
                }
                Spacer()
            }
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text(place.location?.address ?? "")
                    Text(place.location?.postcode ?? "")
                    Text(place.location?.locality ?? "")
                    Text(place.location?.adminRegion ?? "")
                }
                Spacer()
                ZStack {
                    MapView(presentation: .thumbnail(place: place))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .matchedGeometryEffect(id: "map", in: namespace)
                    Button(action: {
                        withAnimation {
                            isShowingModal = true
                        }
                    }, label: {
                        Color.clear
                    })
                }
                .frame(width: 120, height: 120)
            }
        }
        .padding()
        .background(.thinMaterial)
    }
}

struct PlaceHeaderView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        PlaceDetailBodyView(place: place,
                            namespace: namespace,
                            isShowingModal: .constant(false))
            .environmentObject(FavoritesStore())
    }
}
