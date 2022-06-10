//
//  FavoritesView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 29/05/22.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var dataController: DataController

    var favoritesBinding: Binding<[Photo]> {
        Binding {
            dataController.favoriteImages
        } set: { _ in }
    }
    
    var body: some View {
        NavigationView {
            PhotosGridView(photos: favoritesBinding)
                .navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(DataController())
    }
}
