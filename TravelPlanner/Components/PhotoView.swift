//
//  PhotoView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 28/05/22.
//

import SwiftUI

struct PhotoView: View {
    @Binding var photo: Photo
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
        Image(photo: photo)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
            .scaleEffect(scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(geasture)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: .constant(.example))
    }
}
