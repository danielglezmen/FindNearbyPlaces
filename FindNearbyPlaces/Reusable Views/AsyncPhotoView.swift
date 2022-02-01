//
//  AsyncPhotoView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 30/1/22.
//

import SwiftUI

struct AsyncPhotoView: View {
    let photo: Place.Photo
    let points: Int?
    let contentMode: ContentMode
    let cornerRadius: Double
    
    init(photo: Place.Photo,
         points: Int? = nil,
         contentMode: ContentMode = .fit,
         cornerRadius: Double = 0) {
        self.photo = photo
        self.points = points
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
    }
    
    var size: Place.Photo.Size {
        if let points = points {
            return .custom(width: points * 2, height: points * 2)
        } else {
            return .original
        }
    }
    
    var body: some View {
        AsyncImage(url: photo.url(for: size)) { phase in
            if let image = phase.image {
                image // Displays the loaded image.
                    .resizable()
                    .aspectRatio(nil, contentMode: contentMode)
                    .cornerRadius(cornerRadius)
            } else if phase.error != nil {
                Color.gray // Indicates an error.
                    .cornerRadius(cornerRadius)
            } else {
                ProgressView() // Acts as a placeholder.
            }
        }
    }
}

struct AsyncPhotoView_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        AsyncPhotoView(photo: place.photos![0])
    }
}
