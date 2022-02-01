//
//  AutocompleteSearchRowView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 26/1/22.
//

import SwiftUI

struct AutocompleteSearchRow: View {
    var query: String
    
    var body: some View {
        NavigationLink("Search for \(query)",
                       destination: PlaceSearchView(query: query))
    }
}

struct AutocompleteRowView_Previews: PreviewProvider {
    static var previews: some View {
        AutocompleteSearchRow(query: "Italian food")
            .previewLayout(.fixed(width: 320, height: 90.0))
    }
}
