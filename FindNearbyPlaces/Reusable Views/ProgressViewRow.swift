//
//  ProgressViewRow.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 1/2/22.
//

import SwiftUI

struct ProgressViewRow: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct ProgressViewRow_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewRow()
    }
}
