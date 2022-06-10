//
//  PhotosGridView.swift
//  TravelPlanner
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
    
    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 200, height: 200)
    
    private var imageSize: CGSize {
        CGSize(
            width: Self.itemSize.width * min(displayScale, 2),
            height: Self.itemSize.height * min(displayScale, 2)
        )
    }
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: Self.itemSize.width, maximum: Self.itemSize.height))]
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
                        PhotoView(asset: photo, cache: dataController.photoCollection.cache)
                    }
                }
            }
        }
        .navigationBarHidden(selectedPhoto != nil)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if let selectedPhoto = selectedPhoto {
                PhotosTabView(photos: $photos, initialSelection: selectedPhoto, cache: dataController.photoCollection.cache) {
                    withAnimation {
                        self.selectedPhoto = nil
                    }
                }
                .transition(.move(edge: .bottom))
                .background(.ultraThinMaterial)
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
