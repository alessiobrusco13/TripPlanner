//
//  PhotosGridView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 26/05/22.
//

import SwiftUI

// MARK: -Tasks
// - List view (enum)
// - Edit mode (use binding; set view mode to list)

struct PhotosGridView: View {
    @Binding var photos: [PhotoAsset]
    @Binding var selectedPhoto: PhotoAsset?
    let editingEnabled: Bool
    
    @EnvironmentObject private var dataController: DataController
    @Environment(\.displayScale) private var displayScale
    
    private let itemWidth = 180.0
    
    private var imageSize: CGSize {
        CGSize(
            width: 400 * min(displayScale, 2),
            height: 400 * min(displayScale, 2)
        )
    }
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: itemWidth, maximum: itemWidth))]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach($photos) { $photo in
                    Button {
                        withAnimation(.spring()) {
                            selectedPhoto = photo
                        }
                    } label: {
                        photoItemView(asset: photo)
                    }
                }
                .accessibilityHidden(selectedPhoto != nil)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if let selectedPhoto = selectedPhoto {
                PhotosTabView(photos: $photos, initialSelection: selectedPhoto, editingEnabled: editingEnabled) {
                    withAnimation {
                        self.selectedPhoto = nil
                    }
                }
                .transition(.move(edge: .bottom))
                .background(.ultraThinMaterial)
            }
        }
    }
    
    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoView(asset: asset) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: itemWidth, height: itemWidth)
                .cornerRadius(15)
                .onAppear {
                    dataController.startCaching([asset], targetSize: imageSize)
                }
                .onDisappear {
                    dataController.stopCaching([asset], targetSize: imageSize)
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
