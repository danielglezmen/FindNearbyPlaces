//
//  MapViewPresentation.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 31/1/22.
//

import Foundation
import SwiftUI

extension MapView {
    enum Presentation {
        case places(places : [Place])
        case place(place: Place)
        case thumbnail(place: Place)
    }
}

extension MapView.Presentation {
    
    var places: [Place] {
        switch self {
        case .places(let places):
            return places.filter { $0.geocodes != nil }
        case .place(let place), .thumbnail(let place):
            return place.geocodes != nil ? [place] : []
        }
    }
    
    var shouldAddLocation: Bool {
        switch self {
        case .places, .place: return true
        case .thumbnail: return false
        }
    }
    
    var shouldNavigate: Bool {
        switch self {
        case .places: return true
        case .place, .thumbnail: return false
        }
    }
    
    var isDisable: Bool {
        switch self {
        case .places, .place: return false
        case .thumbnail: return true
        }
    }
    
    var accentColor: Color {
        switch self {
        case .places, .place: return .accentColor
        case .thumbnail: return .primary
        }
    }
}
