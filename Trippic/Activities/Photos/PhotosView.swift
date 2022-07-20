//
//  PhotosView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 06/07/22.
//

import SwiftUI

struct PhotosView: View {
    @Binding var photos: [PhotoAsset]
    let editingEnabled: Bool
    
    @EnvironmentObject private var dataController: DataController
    @Environment(\.editMode) private var editMode
    @State private var selectedPhoto: PhotoAsset?
    
    private let itemWidth = 180.0
    
    init(photos: [PhotoAsset]) {
        _photos = .constant(photos)
        editingEnabled = false
    }
    
    init(photos: Binding<[PhotoAsset]>) {
        _photos = photos
        editingEnabled = true
    }
    
    init(photos: Binding<[PhotoAsset]>, selectedPhoto: PhotoAsset) {
        _photos = photos
        editingEnabled = true
        
        self.selectedPhoto = selectedPhoto
    }
    
    var body: some View {
        Group {
            if let editMode = editMode, editMode.wrappedValue == .active {
                PhotosListView(photos: $photos, editingEnabled: editingEnabled)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                PhotosGridView(photos: $photos, selectedPhoto: $selectedPhoto, editingEnabled: editingEnabled)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
        .toolbar {
            if editingEnabled {
                EditButton()
            }
        }
        .animation(.spring(), value: editMode?.wrappedValue)
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView(photos: .example)
    }
}
