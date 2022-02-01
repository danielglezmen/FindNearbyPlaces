//
//  Place.swift
//  FindNearbyPlaces
//
//  Created by Daniel González on 19/1/22.
//

import Foundation
import CoreLocation

// MARK: - Place

struct Place: Identifiable, Codable {
    var id: String { fsqId }
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: Core
    var fsqId: String
    var name: String?
    var categories: [Category]?
    var distance: Int?
    var geocodes: Geocodes?
    var location: Location?
    
    // MARK: Rich
    var description: String?
    var price: Int?
    var rating: Double?
    var tel: String?
    var photos: [Photo]?
}

extension Place {
    
    /// A descritpion string of the distance, converting into meters or kilometers depending on the value.
    var distanceDescription: String {
        guard let distance = distance else { return "" }
        switch distance {
        case let x where x >= 1_000:
            return "\(String(format: "%.1f", Double(x)/1000.0)) kilometers"
        default:
            return "\(distance) meters"
        }
    }
}

// MARK: - Category

extension Place {
    struct Category: Codable, Identifiable {
        var id: Int
        var name: String
        var icon: Icon
    }
}

extension Place.Category {
    struct Icon: Codable {
        var prefix: String
        var suffix: String
    }
}

extension Place.Category.Icon {
    enum Size: String { // 32, 44, 64, 88, or 120 (pixels)
        case size32 = "32"
        case size44 = "44"
        case size64 = "64"
        case size88 = "88"
        case size120 = "120"
        
        /// Frame size in points for retina displays (x2)
        var frame: Double {
            switch self {
            case .size32: return 16.0
            case .size44: return 22.0
            case .size64: return 32.0
            case .size88: return 44.0
            case .size120: return 60.0
            }
        }
    }
    
    func url(for size: Size) -> URL? {
        URL(string: self.prefix + size.rawValue + self.suffix)
    }
    
}

// MARK: - Geocodes

extension Place {
    struct Geocodes: Codable {
        var main: Main
    }
}

extension Place.Geocodes {
    struct Main: Codable {
        var latitude: Double
        var longitude: Double
    }
}

extension Place.Geocodes.Main {
    var locationCordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Location

extension Place {
    struct Location: Codable {
        var address: String?
        var adminRegion: String?
        var country: String?
        var crossStreet: String?
        var locality: String?
        var postcode: String?
        var region: String?
    }
}

// MARK: - Photo

extension Place {
    struct Photo: Codable, Identifiable {
        var id: String {
            self.suffix
        }
        var prefix: String
        var suffix: String
        var width: Int
        var height: Int
    }
}

extension Place.Photo {
    enum Size {
        case original
        case custom(width: Int, height: Int)
    }
    
    func url(for size: Size) -> URL? {
        switch size {
        case .original:
            return URL(string: self.prefix + "original" + self.suffix)
        case .custom(let width, let height):
            return URL(string: self.prefix + String(width) + "x" + String(height) + self.suffix)
        }
    }
}

