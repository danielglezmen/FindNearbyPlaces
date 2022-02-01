//
//  LocationManager.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 29/1/22.
//

import Foundation
import CoreLocation

/// Location manager used to obtain the location using Core Location
///
/// Use the singleton instance .shared to obtain the shared manager through the app.
class LocationManager: NSObject {
    
    // MARK: Public
    
    static let shared = LocationManager()
    // Use New York by deafult 40.7128° N, 74.0060° W
    var currentLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
    
    // MARK: Private
    
    private var manager: CLLocationManager
    private var isAuthorized = false
    
    override init() {
        self.manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        isAuthorized = manager.authorizationStatus == .authorizedWhenInUse ? true : false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
//            manager.stopUpdatingLocation() // TODO: Leave working for testing proposes
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Helpers

extension CLLocation {
    
    /// Create a string description for the following format: *"latitude,longitude"*
    var stringDescription: String {
        String("\(coordinate.latitude),\(coordinate.longitude)")
    }
}
