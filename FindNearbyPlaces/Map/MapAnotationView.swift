//
//  MapAnotationView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 31/1/22.
//

import SwiftUI
import MapKit

struct MapAnotationView: View {
    let place: Place
    let shouldNavigate: Bool
    
    var body: some View {
        if shouldNavigate {
            NavigationLink {
                PlaceDetailView(place: place)
            } label: {
                anotationContentView
            }
        } else {
            anotationContentView
        }
    }
    
    @ViewBuilder
    private var anotationContentView: some View {
        VStack {
            Image(systemName: "mappin.square.fill")
                .font(.title)
            Circle()
                .fill(.primary)
                .frame(width: 3, height: 3)
        }
    }
}

struct MapAnotation_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        MapAnotationView(place: place, shouldNavigate: false)
    }
}
