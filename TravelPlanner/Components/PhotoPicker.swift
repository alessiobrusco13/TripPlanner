//
//  PhotoPicker.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 18/05/22.
//

import SwiftUI

struct PhotoPicker<Content: View>: View {
    @Binding var selection: UIImage?
    @Binding var identifier: String?
    @ViewBuilder let label: () -> Content

    @State private var showingImagePicker = false
    @State private var showingCamera = false

    var body: some View {
        Menu(content: imageButtons, label: label)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selection, identifier: $identifier)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showingCamera) {
            Camera(image: $selection)
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    func imageButtons() -> some View {
        Button {
            showingImagePicker.toggle()
        } label: {
            Label("Photo Library", systemImage: "photo.on.rectangle")
        }

        Button {
            #if targetEnvironment(simulator)
            selection = [UIImage].example.randomElement()!
            #else
            showingCamera.toggle()
            #endif
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(selection: .constant(nil), identifier: .constant(nil)) { EmptyView() }
    }
}
