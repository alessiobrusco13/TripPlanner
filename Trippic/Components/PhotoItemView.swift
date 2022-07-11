//
//  PhotoItemView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/07/22.
//

import SwiftUI

struct PhotoItemView: View {
    @Binding var asset: PhotoAsset
    let action: () -> Void
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.displayScale) private var displayScale
    
    static let itemWidth = 180.0
    
    var imageSize: CGSize {
        CGSize(
            width: 400 * min(displayScale, 2),
            height: 400 * min(displayScale, 2)
        )
    }
    
    var body: some View {
        Button(action: action) {
            PhotoView(asset: asset) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.itemWidth, height: Self.itemWidth)
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
}

struct PhotoItemView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoItemView(asset: .constant(.example)) { }
            .environmentObject(DataController())
    }
}
