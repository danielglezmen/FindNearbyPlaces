//
//  SearchField.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 28/1/22.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.headline)
            TextField("Search for places", text: $searchText) { isEditing in
                if isEditing || (!isEditing && searchText.isEmpty) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearching = isEditing
                    }
                }
            }
        }
        .padding([.all], 7)
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5))
        .padding(10)
        .background(.regularMaterial)
        .cornerRadius(isSearching ? 0 : 10)
        .frame(maxWidth: isSearching ? .infinity : 300)
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(searchText: Binding.constant(""),
                    isSearching: Binding.constant(false))
    }
}
