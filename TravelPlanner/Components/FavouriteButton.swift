//
//  FavouriteButton.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 31/05/22.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var photo: Photo
    let location: Location?

    var body: some View {
        Button {
            withAnimation {
                location?.objectWillChange.send()
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
