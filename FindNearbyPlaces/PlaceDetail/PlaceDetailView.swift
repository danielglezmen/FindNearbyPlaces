//
//  PlaceDetailView.swift
//  FindNearbyPlaces
//
//  Created by Daniel González Méndez on 28/1/22.
//

import SwiftUI

struct PlaceDetailView: View {
    @State var place: Place
    var needsAdditionalLoading = false
    @Namespace var namespace
    @State private var isShowingModal = false
    
    var body: some View {
        ZStack {
            if isShowingModal == false {
                ScrollView {
                    PlaceDetailHeaderView(place: place)
                    PlaceDetailBodyView(place: place,
                                        namespace: namespace,
                                        isShowingModal: $isShowingModal)
                    Divider()
                    PlaceDetailPhotosView(place: place)
                }
                
            } else {
                MapView(presentation: .place(place: place))
                    .matchedGeometryEffect(id: "map", in: namespace)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                isShowingModal = false
                            }
                        } label: {
                            Text("Close map")
                        }
                        .padding(20)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                        .zIndex(1)
                    }
                    .padding(.trailing, 30)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .navigationBarHidden(isShowingModal ? true : false)
        .navigationBarBackButtonHidden(isShowingModal ? true : false)
        .task {
            if needsAdditionalLoading { // Load more data for the place
                do {
                    place = try await PlaceDetailStore.getDetailPlace(from: place)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var place = LocalFileManager.load(
        jsonFileName: "SinglePlaceCore",
        type: Place.self)
    static var previews: some View {
        NavigationView {
            PlaceDetailView(place: place)
        }
        .preferredColorScheme(.dark)
        .environmentObject(FavoritesStore())
    }
}
