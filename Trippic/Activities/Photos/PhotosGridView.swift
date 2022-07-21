//
//  PhotosGridView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 26/05/22.
//

import SwiftUI

struct PhotosGridView: View {
    @Binding var photos: [PhotoAsset]
    let editingEnabled: Bool
    
    @State private var selectedPhoto: PhotoAsset?
    @State private var editingSelection = Set<PhotoAsset>()
    @State private var showingFavorites = false
    
    @EnvironmentObject private var dataController: DataController
    @Environment(\.editMode) private var editMode
    @Environment(\.displayScale) private var displayScale
    @Environment(\.dismiss) private var dismiss
    
    var imageSize: CGSize {
        CGSize(
            width: 400 * min(displayScale, 2),
            height: 400 * min(displayScale, 2)
        )
    }
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: PhotoItemView.itemWidth, maximum: PhotoItemView.itemWidth))]
    }
    
    init(photos: [PhotoAsset]) {
        _photos = .constant(photos)
        editingEnabled = false
    }
    
    init(photos: Binding<[PhotoAsset]>) {
        _photos = photos
        editingEnabled = true
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
                    PhotoItemView(asset: $photo, editingSelection: $editingSelection) {
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
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 20) {
                    Button {
                        withAnimation(.spring()) {
                            showingFavorites.toggle()
                        }
                    } label: {
                        Image(systemName: showingFavorites ? "heart.slash" : "heart")
                    }
                    
                    if editingEnabled {
                        EditButton()
                            .disabled(photos.isEmpty)
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                if editMode?.wrappedValue.isEditing ?? false {
                    HStack {
                        Spacer()

                        DeleteButton(data: $photos, selection: $editingSelection)
                    }
                }
            }
        }
        .onChange(of: showingFavorites) { _ in
            withAnimation(.spring()) {
                selectedPhoto = nil
            }
        }
        .onChange(of: editMode?.wrappedValue) { _ in
            guard !editingSelection.isEmpty else { return }
            editingSelection.removeAll()
        }
        .onChange(of: photos) { newValue in
            if newValue.isEmpty {
                dismiss()
            }
        }
    }
}

struct PhotosGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosGridView(photos: .constant(.example))
            .environmentObject(DataController())
    }
}
