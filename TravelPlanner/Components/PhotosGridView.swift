//
//  PhotosGridView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 26/05/22.
//

import SwiftUI

struct PhotosGridView: View {
    @EnvironmentObject private var dataController: DataController

    @Binding var photos: [Photo]
    let itemSize: CGSize

    @Environment(\.dismiss) var dismiss
    @Environment(\.displayScale) private var displayScale

    @State private var isPresenting = false
    
    private static let itemCornerRadius = 15.0

    private var imageSize: CGSize {
        CGSize(
            width: itemSize.width * min(displayScale, 2),
            height: itemSize.height * min(displayScale, 2)
        )
    }

    private var columns: [GridItem] { [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height))
    ] }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
//                ForEach(photoCollection.photoAssets) { asset in
//                    NavigationLink {
//                        PhotoView(asset: asset, cache: photoCollection.cache)
//                    } label: {
//                        photoItemView(asset: asset)
//                    }
//                    .buttonStyle(.borderless)
//                    .accessibilityLabel(asset.accessibilityLabel)
//                }

                ForEach($photos) { $photo in
                    Image(photo: photo)
                        .resizable()
                        .frame(width: itemSize.width, height: itemSize.height)
                        .cornerRadius(Self.itemCornerRadius)
                        .onTapGesture {
                            isPresenting.toggle()
                        }
                        .sheet(isPresented: $isPresenting) {
                            if let location = dataController.location(for: photo), let trip = dataController.trip(for: location) {
                                TripView(trip: trip)
                            }
                        }
                }
            }
        }
    }


}

struct PhotosGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosGridView(photos: .constant(.example), itemSize: .zero)
            .environmentObject(DataController())
    }
}
