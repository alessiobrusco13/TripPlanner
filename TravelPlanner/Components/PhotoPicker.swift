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
    let label: () -> Content

    @State private var showingImagePicker = false
    @State private var showingCamera = false
    
    init(selection: Binding<UIImage?>, @ViewBuilder label: @escaping () -> Content) {
        _selection = selection
        self.label = label
        _identifier = .constant(nil)
    }
    
    init(identifier: Binding<String?>, @ViewBuilder label: @escaping () -> Content) {
        _identifier = identifier
        self.label = label
        _selection = .constant(nil)
    }

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
        PhotoPicker(selection: .constant(nil)) { EmptyView() }
    }
}
