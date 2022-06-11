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
                    .scaledToFill()
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
                    } else {
                        print("\n\n\nTHERE WAS A PROBLEM LOADING THE IMAGE\n\n\n")
                    }
                }
            }
            
//            guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [asset.identifier], options: nil).firstObject else {
//                print("\n\n\nCOULDN'T FIND ANY ASSETS\n\n\n")
//                return
//            }
//
            
//            guard let phAsset = asset.phAsset else {
//                print("Nil")
//                return
//            }
//            let manager = PHImageManager.default()
//            manager.requestImage(for: phAsset, targetSize: CGSize(width: 1024, height: 1024), contentMode: .aspectFill, options: nil) { image, _ in
//                if let image = image {
//                    self.image = Image(uiImage: image)
//                } else {
//                    print("\n\n\nFAILED TO LOAD IMAGE FROM ASSET\n\n\n")
//                }
//            }
        }
    }
}
