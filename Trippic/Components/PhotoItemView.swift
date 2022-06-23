//
//  PhotoItemView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/06/22.
//

import Photos
import SwiftUI

struct PhotoItemView: View {
    @EnvironmentObject private var dataController: DataController
    
    var asset: PhotoAsset
    var cache: CachedImageManager?
    var imageSize: CGSize
    
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?

    var body: some View {
        
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .task {
            if asset.phAsset == nil, let path = dataController.path(for: asset) {
                withAnimation {
                    _ = dataController.trips[path.tripIndex].locations[path.locationIndex].photos.remove(at: path.photoIndex)
                }
            }
            
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
}

struct PhotoItemView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoItemView(asset: .example, cache: .init(), imageSize: CGSize(width: 550, height: 550))
    }
}
