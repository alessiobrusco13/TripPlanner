//
//  PhotoView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos
import SwiftUI

struct PhotoView: View {
    @EnvironmentObject private var dataController: DataController
    
    var asset: PhotoAsset
    var cache: CachedImageManager?
    
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            }
        }
        .task {
            if asset.phAsset == nil, let path = dataController.path(for: asset) {
                withAnimation {
                    _ = dataController.trips[path.tripIndex].locations[path.locationIndex].photos.remove(at: path.photoIndex)
                }
            }
            
            guard image == nil, let cache = cache else { return }
            
            imageRequestID = await cache.requestImage(for: asset, targetSize: CGSize(width: 1024, height: 1024)) { result in
                Task {
                    if let result = result {
                        image = result.image
                    }
                }
            }
        }
    }
}
