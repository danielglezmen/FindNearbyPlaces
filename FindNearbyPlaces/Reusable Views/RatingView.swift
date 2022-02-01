//
//  RatingView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 26/1/22.
//

import SwiftUI

struct RatingView: View {
    let rating: Double?
    let font: Font
    
    var formatedValue: String? {
        if let rating = rating {
            return String(String(format: "%.1f", rating))
        } else {
            return nil
        }
    }
    var color: Color {
        guard let rating = rating else { return .gray }
        switch rating {
        case let x where x < 5.0:
            return .red
        case let x where x >= 5 && x < 6:
            return .orange
        case let x where x >= 6 && x < 7:
            return .yellow
        case let x where x >= 7:
            return .green
        default:
            return .gray
        }
    }
    
    var body: some View {
        if let formatedValue = formatedValue {
            Text(formatedValue)
                .font(font)
                .bold()
                .foregroundColor(.primary)
                .padding(font == .title ? 6 : 3)
                .background(color)
                .cornerRadius(font == .title ? 7 : 5)
        } else {
            EmptyView()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 9.12, font: .body)
            .previewLayout(.fixed(width: 100, height: 100))
        RatingView(rating: 5.4523, font: .title)
            .previewLayout(.fixed(width: 100, height: 100))
        RatingView(rating: 3, font: .callout)
            .previewLayout(.fixed(width: 100, height: 100))
        RatingView(rating: nil, font: .body)
            .previewLayout(.fixed(width: 100, height: 100))
    }

}
