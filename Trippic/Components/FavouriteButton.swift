//
//  FavouriteButton.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 31/05/22.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var photo: PhotoAsset

    var body: some View {
        Button {
            withAnimation {
                photo.isFavorite.toggle()
            }
        } label: {
            Image(systemName: "heart")
                .symbolVariant(photo.isFavorite ? .fill : .none)
                .foregroundStyle(.red)
                .font(.largeTitle)
        }
    }
}
