//
//  PhotoPageView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 28/05/22.
//

import SwiftUI

struct PhotoPageView: View {
    @Binding var photo: PhotoAsset
    var cache: CachedImageManager
    @State private var scale = 1.0

    var geasture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                withAnimation(.spring()) {
                    scale = value
                }
            }
            .onEnded { _ in
                withAnimation(.spring()) {
                    scale = 1
                }
            }
    }

    var body: some View {
        PhotoView(asset: photo, cache: cache)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
            .scaleEffect(scale)
            .gesture(geasture)
    }
}

struct PhotoPageView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPageView(photo: .constant(.example), cache: .init())
    }
}
