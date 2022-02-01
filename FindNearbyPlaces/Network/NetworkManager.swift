//
//  NetworkManager.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 23/1/22.
//

import Foundation
import Combine

class NetworkManager {
    
    // MARK: Public
    
    /// Create a combine publisher to request data to the endpoint and decode the response into a type codable instance.
    ///
    /// - Parameters:
    ///    - type: The type of the object to decode.
    ///    - endpoint: The endpoint to request the data.
    ///    - retries: The number of retries if a error raises.
    /// - Returns: A combine publisher for subcriptions.
    func publisher<T: Decodable>(for type: T.Type,
                                 endpoint: URLEndpoint,
                                 retries: Int = 0) -> AnyPublisher<T,Error> {
        let request = try! urlRequest(endpoint: endpoint) // TODO: throws

        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(retries)
            .tryMap() { element -> Data in
                try self.checkError(response: element.response)
                return element.data
            }
            .decode(type: T.self, decoder: SnakeCaseJSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Request asynchronous data from the endpoint and decode the response into a type codable instance.
    /// - Parameters:
    ///    - type: The type of the object to decode.
    ///    - endpoint: The endpoint to request the data.
    /// - Returns: The decoded object.
    func request<T: Decodable>(type: T.Type,
                               endpoint: URLEndpoint) async throws -> T {
        let request = try urlRequest(endpoint: endpoint)
        do {
            let response = try await URLSession.shared.data(for: request, delegate: nil)
            try checkError(response: response.1)
            return try Place.jsonDecoder.decode(T.self, from: response.0)
        } catch {
            throw URLError(.badServerResponse)
        }
    }
    
    // MARK: Private
    
    private func urlRequest(endpoint: URLEndpoint) throws -> URLRequest {
        var request = URLRequest(url: try! endpoint.url) // TODO: throws
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        request.cachePolicy = .useProtocolCachePolicy
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
    
    private func checkError(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw URLError(.badServerResponse)
              }
    }
}
