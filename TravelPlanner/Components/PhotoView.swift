//
//  PhotoView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos
import SwiftUI

struct PhotoView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    
    var body: some View {
         Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
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
