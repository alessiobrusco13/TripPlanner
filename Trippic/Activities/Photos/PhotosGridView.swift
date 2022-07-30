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
    let startingSelection: PhotoAsset?
    
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
        startingSelection = nil
    }
    
    init(photos: Binding<[PhotoAsset]>, startingSelection: PhotoAsset? = nil) {
        _photos = photos
        editingEnabled = true
        self.startingSelection = startingSelection
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
                    .deleteContextMenu(contentShape: Rectangle(), enabled: editingEnabled) {
                        delete(photo)
                    }
                }
                .accessibilityHidden(selectedPhoto != nil)
            }
            .frame(maxWidth: .infinity)
        }
        .animation(.default, value: photos)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedPhoto) { selection in
            PhotosTabView(photos: $photos, initialSelection: selection, editingEnabled: true)
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
                    .disabled(
                        selectedPhoto != nil
                        || editMode?.wrappedValue.isEditing ?? false
                    )
                    
                    if editingEnabled && !photos.isEmpty {
                        EditButton()
                            .frame(width: 55)
                            .disabled(
                                selectedPhoto != nil
                                || showingFavorites
                            )
                    }
                }
            }
        }
        .deleteButton(data: $photos, selection: $editingSelection)
        .onChange(of: showingFavorites) { _ in
            withAnimation(.spring()) {
                selectedPhoto = nil
            }
        }
        .onChange(of: photos) { newValue in
            if newValue.isEmpty {
                dismiss()
            }
        }
        .onChange(of: editMode?.wrappedValue) { _ in
            guard editingSelection.isEmpty == false else { return }
            editingSelection.removeAll()
        }
        .task {
            if let startingSelection = startingSelection {
                try? await Task.sleep(nanoseconds: 100_000_000)
                
                withAnimation(.spring()) {
                    selectedPhoto = startingSelection
                }
            }
        }
    }
    
    func delete(_ photo: PhotoAsset) {
        guard let index = photos.firstIndex(of: photo) else { return }
        photos.remove(at: index)
        dataController.stopCaching([photo], targetSize: imageSize)
    }
}

struct PhotosGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosGridView(photos: .constant(.example))
            .environmentObject(DataController())
    }
}
