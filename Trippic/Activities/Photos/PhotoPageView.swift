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
        ZStack {
            PhotoView(asset: photo) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
            }
            .pinchToZoom()
            .padding()
            .padding(.bottom, 70)
        }
    }
}

struct PhotoPageView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPageView(photo: .constant(.example), editingEnabled: true)
    }
}
