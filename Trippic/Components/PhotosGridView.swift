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
    
    @EnvironmentObject private var dataController: DataController
    @State private var selectedPhoto: PhotoAsset?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.displayScale) private var displayScale
    
    private var imageSize: CGSize {
        CGSize(
            width: 200 * min(displayScale, 2),
            height: 200 * min(displayScale, 2)
        )
    }
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150, maximum: 200))]
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
            }
            .frame(maxWidth: .infinity)
            .padding(8)
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if let selectedPhoto = selectedPhoto {
                PhotosTabView(photos: $photos, initialSelection: selectedPhoto) {
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
                .aspectRatio(1, contentMode: .fill)
                .clipped()
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
        PhotosGridView(photos: .constant(.example))
            .environmentObject(DataController())
    }
}
