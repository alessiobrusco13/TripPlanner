//
//  PhotosGridView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 26/05/22.
//

import SwiftUI

struct PhotosGridView: View {
    @Binding var photos: [PhotoAsset]
    @Binding var selectedPhoto: PhotoAsset?
    let editingEnabled: Bool
    
    @EnvironmentObject private var dataController: DataController
    @State private var showingFavorites = false
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: PhotoItemView.itemWidth, maximum: PhotoItemView.itemWidth))]
    }
    
    var filteredPhotos: Binding<[PhotoAsset]> {
        if showingFavorites {
            return Binding {
                photos.filter(\.isFavorite)
            } set: { newPhotos in
                for photo in newPhotos {
                    guard let index = photos.firstIndex(of: photo) else { continue }
                    guard photo.isFavorite != photos[index].isFavorite else { continue }
                    photos[index].isFavorite = photo.isFavorite
                }
            }
        } else {
            return $photos
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(filteredPhotos) { $photo in
                    PhotoItemView(asset: $photo) {
                        withAnimation(.spring()) {
                            selectedPhoto = photo
                        }
                    }
                }
                .accessibilityHidden(selectedPhoto != nil)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if let selectedPhoto = selectedPhoto {
                PhotosTabView(photos: filteredPhotos, initialSelection: selectedPhoto, editingEnabled: editingEnabled) {
                    withAnimation {
                        self.selectedPhoto = nil
                    }
                }
                .transition(.move(edge: .bottom))
                .background(.ultraThinMaterial)
            }
        }
        .toolbar {
            Button {
                withAnimation(.spring()) {
                    showingFavorites.toggle()
                }
            } label: {
                Image(systemName: showingFavorites ? "heart.slash" : "heart")
            }
        }
        .onChange(of: showingFavorites) { _ in
            withAnimation(.spring()) {
                selectedPhoto = nil
            }
        }
    }
}

struct PhotosGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosGridView(photos: .constant(.example), selectedPhoto: .constant(.example), editingEnabled: false)
            .environmentObject(DataController())
    }
}
