//
//  PlaceDetailHeaderView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 31/1/22.
//

import SwiftUI

struct PlaceDetailHeaderView: View {
    let place: Place
    @Environment(\.colorScheme) var colorScheme
    
    var gradientColors: [Color] {
        colorScheme == .dark ? [.black, .clear] : [.white, .clear]
    }
    
    var body: some View {
        ZStack {
            if let photo = place.photos?.first {
                AsyncPhotoView(photo: photo, points: 300, contentMode: .fill)
                LinearGradient(colors: gradientColors,
                               startPoint: .top,
                               endPoint: .bottom)
            }
        }
        .frame(height: 300)
    }
}

struct PlaceDetailHeaderView_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        PlaceDetailHeaderView(place: place)
    }
}
