//
//  BackgroundView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 1/2/22.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(AngularGradient(colors: [.pink, .purple],
                                  center: .leading,
                                  angle: .degrees(180)))
            .ignoresSafeArea()
            .transition(.opacity)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
