//
//  PlaceDetailPhotosView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 31/1/22.
//

import SwiftUI

struct PlaceDetailPhotosView: View {
    let place: Place
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20.0) {
                ForEach(place.photos ?? []) { photo in
                    AsyncPhotoView(photo: photo,
                                   points: 200,
                                   contentMode: .fit,
                                   cornerRadius: 10)
                        .frame(width: 200)
                }
            }
        }
        .padding([.leading, .trailing])
    }
}

struct PlaceDetailPhotosVIew_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        PlaceDetailPhotosView(place: place)
    }
}
