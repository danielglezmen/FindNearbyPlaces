//
//  AutocompleteStore.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 28/1/22.
//

import Foundation
import Combine

class AutocompleteStore: ObservableObject {
    // MARK: Public
    
    @Published var searchText = ""
    @Published var autocompletes = [AutocompleteResponse.Result]()
    @Published var isSearching = false
    
    init() {
        locationManager = LocationManager.shared // Instanciate the singleton in the main thread
        $searchText
            .filter { $0.count >= 3 }
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                print("Autocomplete search: \(searchText)...")
                self?.isSearching = true
                self?.autocomplete(searchText)
            }.store(in: &subscription)
    }
    
    // MARK: Private
    
    private var locationManager: LocationManager
    private var subscription: Set<AnyCancellable> = []
    private var networkSubscription: AnyCancellable? // Avoid multiple concurrent requests using ARC.
    
    private func autocomplete(_ text: String) {
        let endpoint = PlacesEndpoint.autocomplete(query: text,
                                                   location: locationManager.currentLocation.stringDescription)
        networkSubscription = NetworkManager().publisher(for: AutocompleteResponse.self,
                                                            endpoint: endpoint)
            .sink { [weak self] completion in
                self?.isSearching = false
                if case let .failure(error) = completion {
                    print(error.localizedDescription) // TODO: Better management
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.autocompletes = result.results.sorted { $0.type != $1.type && $0.type == .search }
            }
    }
}
