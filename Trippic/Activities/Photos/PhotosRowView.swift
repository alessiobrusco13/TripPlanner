//
//  PhotosRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 23/07/22.
//

import SwiftUI

struct PhotosRowView: View {
    @Binding var photos: [PhotoAsset]
    
    var body: some View {
        ForEach($photos) { $photo in
            NavigationLink {
                PhotosGridView(photos: $photos, startingSelection: photo)
            } label: {
                PhotoView(asset: photo) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 225, height: 225)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .overlay(alignment: .topTrailing) {
                            FavoriteButton(photo: $photo)
                                .padding(5)
                                .transition(.scale)
                        }
                }
            }
            .buttonStyle(.outline)
            .id(photo.id)
        }
        .animation(.default, value: photos)
    }
}

struct PhotosRowView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosRowView(photos: .constant(.example))
    }
}
