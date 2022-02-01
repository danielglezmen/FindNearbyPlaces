//
//  CategoryView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 28/1/22.
//

import SwiftUI

struct CategoryView: View {
    let categories: [Place.Category]
    var size: Place.Category.Icon.Size = .size44
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(categories, id: \.id) { category in
                AsyncImage(url: category.icon.url(for: size)) { image in
                    image
                        .resizable()
                        .renderingMode(.template)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: size.frame, height: size.frame)
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    
    static var previews: some View {
        CategoryView(categories: place.categories ?? [])
            .previewLayout(.fixed(width: 320, height: 90.0))
    }
}
