//
//  PhotoView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos
import SwiftUI

struct PhotoView<Content: View>: View {
    let asset: PhotoAsset
    @ViewBuilder let content: (Image) -> Content
    
    @EnvironmentObject private var dataController: DataController
    @State private var image: Image?
    
    var body: some View {
        Group {
            if let image = image {
                content(image)
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .task {
            guard image == nil else { return }
            
            dataController.requestImage(for: asset, targetSize: CGSize(width: 1024, height: 1024)) { result in
                Task { @MainActor in
                    switch result {
                    case .success(let image):
                        self.image = image
                    case .failure(let error):
                        print(error)
                        
                        if case .assetNotFound = error, let path = dataController.path(for: asset) {
                            withAnimation {
                                _ = dataController.trips[path.tripIndex].locations[path.locationIndex].photos.remove(at: path.photoIndex)
                            }
                        }
                    }
                }
            }
        }
    }
}
