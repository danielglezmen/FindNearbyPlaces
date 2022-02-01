//
//  PlacesEndpoint.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 24/1/22.
//

import Foundation

// MARK: - Endpoint protocol

protocol URLEndpoint {
    var url: URL { get throws }
    var headers: [String: String] { get }
}

extension URLEndpoint {
    var headers: [String: String] {
        ["Accept": "application/json",
        "Authorization": "fsq3sDDRMyBBY7hSYc9+Vr3ZhvsANu94uRnHSYK6qNZx+mA=", // TODO: Add your key here
         "Accept-Language": "en"]
    }
}

// MARK: - Endpoint

extension URLEndpoint {
    
    /// This is a specific character set for allowed characters in the Foursquare Places API v3.
    ///
    /// According to the RFC, some characters  may need percent scaping in section 2.2. Reserved Characters.
    /// The sub-delims must be percent encoding if there ir some conflict for the specific URL component.
    /// https://datatracker.ietf.org/doc/html/rfc3986#section-2.2
    /// ```
    /// reserved = gen-delims / sub-delims
    /// gen-delims = ":" / "/" / "?" / "#" / "[" / "]" / "@"
    /// sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
    /// ```
    ///
    /// Somehow the Apple CharacterSet .URLQueryAllowedCharacterSet is not scaping some characters the
    /// Foursquare API is expecting to. For example "," are not allowed in the query param, when according to the RFC
    /// when in section 3.4 Query the reserved are query = *( pchar / "/" / "?" ).
    ///
    /// This character set includes all characters but not in the *gen-delims* and *sub-delims* in addition to spaces for the query parameter.
    static var urlAllowedCharacterSet: CharacterSet {
        CharacterSet(charactersIn: ":/?#[]@!$&'()*+,;= ").inverted
    }
}

enum URLEndpointError: Swift.Error {
    case invalidURL
    case invalidPaginationLink(link: String)
}

// MARK: - Places

struct PlacesEndpoint: URLEndpoint { // TODO: Pagination?
    var path: String
    var queryItems: [URLQueryItem]
}

extension PlacesEndpoint {
    var url: URL {
        get throws {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.foursquare.com"
            components.path = "/v3" + path
            let query =  queryItems.filter {
                guard let value = $0.value else { return false }
                return !value.isEmpty
            }.map { URLQueryItem(name: $0.name,
                                 value: $0.value?.addingPercentEncoding(withAllowedCharacters: Self.urlAllowedCharacterSet)!) }
            components.percentEncodedQueryItems = query
            
            guard let url = components.url else {
                throw URLEndpointError.invalidURL
            }
            return url
        }
    }
}

extension PlacesEndpoint {
    
    /// Create and enpoint to query the Autocomple API of the Foursquare Places v3.
    ///
    /// URL of the endpoint:
    /// ```
    /// https://api.foursquare.com/v3/autocomplete
    /// ```
    ///
    /// - Parameters:
    ///   - query: The query string to search.
    ///   - location: The coordinates following the expresion: "28.47697,-16.30854"
    /// - Returns: A places endpoint.
    static func autocomplete(query: String,
                             location: String) -> PlacesEndpoint {
        PlacesEndpoint(path: "/autocomplete",
                       queryItems:  [
                        "query": query,
                        "ll": location,
                        "types": Self.autocompleteTypes.joined(separator: ","),
                        "limit": "20"
                       ].map { URLQueryItem(name: $0.key, value: $0.value) })
    }
    
    /// Create an endpoint to query the Place Search API of the Foursquare Places v3.
    ///
    /// URL of the endpoint:
    /// ```
    /// https://api.foursquare.com/v3/places/search
    /// ```
    ///
    /// - Parameters:
    ///   - query: The query string to search.
    ///   - categories: An arrays of categories ids, defined by Foursquare.
    ///   - location: The coordinates following the expresion: "28.47697,-16.30854"
    /// - Returns: A places endpoint.
    static func placeSearch(query: String,
                            categories: [String],
                            location: String) -> PlacesEndpoint {
        PlacesEndpoint(path: "/places/search",
                       queryItems: [
                        "query": query,
                        "fields": Self.searchPlaceFields.joined(separator: ","),
                        "categories": categories.joined(separator: ","),
                        "ll": location,
                        "limit": "20"
                       ].map { URLQueryItem(name: $0.key, value: $0.value) }
        )
    }
    
    /// Create an endpoint to query the Get Detail Place of the Foursquare Places v3.
    ///
    /// URL of the endpoint:
    /// ```
    /// https://api.foursquare.com/v3/places/{fsq_id}
    /// ```
    /// - Parameter fsqId: The identifiers of the place, defined by Foursquare.
    /// - Returns: A places endpoint.
    static func placeDetail(fsqId: String) -> PlacesEndpoint {
        PlacesEndpoint(path: "/places/\(fsqId)",
                       queryItems: [URLQueryItem(name: "fields",
                                                 value: Self.searchPlaceFields.joined(separator: ","))
                                   ]
        )
    }
}

extension PlacesEndpoint {
    static let coreFields = ["fsq_id", "name", "categories", "distance", "geocodes"]
    static let richFields = ["description", "price", "rating", "tel", "photos"]
    static let searchPlaceFields = ["fsq_id", "name", "categories", "distance", "geocodes", "rating", "location", "photos"]
    static let autocompleteTypes = ["search", "place"]
}



// MARK: - Pagination

struct PlacesPaginationEndpoint {
    var link: String
}

extension PlacesPaginationEndpoint: URLEndpoint {
    var url: URL {
        get throws {
            let nextURL = try nextURL(from: link)
            guard let url = URL(string: nextURL) else {
                throw URLEndpointError.invalidURL
            }
            return url
        }
    }
    
    /// Matches the contained URL in the link string and check that the rel property is next.
    ///
    /// Use this function to match the following pattern
    /// ```
    /// <https://api.foursquare.com/v3/places/search?ll=28.47697%2C-16.30854&cursor=c3I6MTA&sort=RATING&query=pizzeria>; rel="next"
    /// ```
    ///
    /// - Parameter link: The header link provided by the Foursquare API v3.
    /// - Returns: The first capturing group, representing an URL.
    private func nextURL(from link: String) throws -> String {
        let regex = try NSRegularExpression(pattern: "<(.*)>.*rel=\"(.*)\"")
        let matches = regex.matches(in: link, options: .anchored, range: NSMakeRange(0, link.count))
        guard matches.count == 2,
              let firstRange = Range(matches[0].range, in: link),
              let secondRange = Range(matches[1].range, in: link),
              link[secondRange] == "next" else {
            throw URLEndpointError.invalidPaginationLink(link: link)
        }
        
        return String(link[firstRange])
    }
}

