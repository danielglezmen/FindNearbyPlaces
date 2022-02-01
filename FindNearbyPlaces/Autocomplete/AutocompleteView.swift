//
//  AutocompleteView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González on 19/1/22.
//

import SwiftUI

struct AutocompleteView: View {
    @StateObject private var store = AutocompleteStore()
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if isSearching == false {
                    BackgroundView()
                }
                VStack(spacing: 0) {
                    if isSearching == false {
                        Spacer()
                        Text("Find nearby places")
                            .font(.title)
                            .padding()
                    }
                    SearchField(searchText: $store.searchText, isSearching: $isSearching)
                    if isSearching == false {
                        Spacer()
                    }
                    if isSearching == true {
                        List {
                            if store.isSearching {
                                ProgressViewRow()
                            } else if store.autocompletes.isEmpty {
                                Text("Write at least 3 letters...")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                            ForEach(store.autocompletes) { result in
                                if let place = result.place {
                                    AutocompletePlaceRow(place: place)
                                } else if let search = result.search {
                                    AutocompleteSearchRow(query: search.query)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AutocompleteView()
            .preferredColorScheme(.dark)
.previewInterfaceOrientation(.portrait)
    }
}
