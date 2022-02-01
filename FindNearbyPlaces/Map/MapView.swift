//
//  MapView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 29/1/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    let presentation: Presentation
    @State private var mapRect = MKMapRect()
    
    private var places: [Place] {
        presentation.places.filter { $0.geocodes != nil }
    }
    
    var body: some View {
        Map(mapRect: $mapRect,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: places) { place in
            MapAnnotation(coordinate: place.geocodes!.main.locationCordinate,
                          anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                MapAnotationView(place: place,
                                 shouldNavigate: presentation.shouldNavigate)
            }
        }
            .disabled(presentation.isDisable)
            .onAppear {
                computeMapRect()
            }
            .ignoresSafeArea(edges: [.bottom])
    }
    
    // MARK: Map computations
    
    private static let mapInsets = -1000.0
    
    private func computeMapRect() {
        var points = presentation.places
            .compactMap(\.geocodes?.main.locationCordinate)
            .map(MKMapPoint.init)
        if presentation.shouldAddLocation {
            points.append(MKMapPoint(LocationManager.shared.currentLocation.coordinate))
        }
        mapRect = points.reduce(MKMapRect.null) { rect, point in
            let newRect = MKMapRect(origin: point, size: MKMapSize())
            return rect.union(newRect)
        }.insetBy(dx: Self.mapInsets, dy: Self.mapInsets)
    }
}

struct PlaceSearchMapView_Previews: PreviewProvider {
    static var places = LocalFileManager.load(
        jsonFileName: "SearchPlaceResponse",
        type: SearchPlaceResponse.self).results
    static var previews: some View {
        MapView(presentation: .places(places: places))
    }
}
