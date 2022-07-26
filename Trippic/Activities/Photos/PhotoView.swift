//
//  PhotoView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos
import SwiftUI

struct PhotoView<Content: View>: View {
    @Binding var asset: PhotoAsset
    let content: (Image) -> Content
    
    @EnvironmentObject private var dataController: DataController
    @State private var image: Image?
    
    init(asset: Binding<PhotoAsset>, @ViewBuilder content: @escaping (Image) -> Content) {
        _asset = asset
        self.content = content
    }
    
    init(asset: PhotoAsset, @ViewBuilder content: @escaping (Image) -> Content) {
        _asset = .constant(asset)
        self.content = content
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(image)
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .onAppear(perform: requestImage)
        .onChange(of: asset) { _ in
            requestImage()
        }
    }
    
    func requestImage() {
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
