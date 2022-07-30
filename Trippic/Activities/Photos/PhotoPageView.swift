//
//  PhotoPageView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 28/05/22.
//

import SwiftUI

struct PhotoPageView: View {
    @Binding var photo: PhotoAsset
    let editingEnabled: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                PhotoView(asset: photo) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .frame(maxWidth: geo.size.width * 0.9, maxHeight: geo.size.height * 0.9)
                }
                .pinchToZoom()
//                .padding(.bottom, 70)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct PhotoPageView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPageView(photo: .constant(.example), editingEnabled: true)
    }
}
