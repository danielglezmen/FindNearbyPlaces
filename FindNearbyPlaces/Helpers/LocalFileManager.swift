//
//  LocalFileManager.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 26/1/22.
//

import Foundation

/// LocalFileManager is used to load local resources for previews and tests proposes.
class LocalFileManager {
  
    static func load<T: Codable>(jsonFileName: String, type: T.Type) -> T {
        do {
            let data = load(jsonFileName: jsonFileName)
            return try Place.jsonDecoder.decode(T.self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func load(jsonFileName: String) -> Data {
        do {
            guard let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") else {
                fatalError("Invalid URL")
            }
            let string = try String(contentsOfFile: path)
            guard let data = string.data(using: .utf8) else { fatalError("Cannot convert to data") }
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

