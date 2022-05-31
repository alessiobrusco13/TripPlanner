//
//  PhotoPicker.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 18/05/22.
//

import SwiftUI

struct PhotoPicker<Content: View>: View {
    private enum OutputMethod {
        case array, atomic, image
    }

    private let outputMethod: OutputMethod
    @State private var selection: UIImage?

    @Binding var atomicSelection: Photo?
    @Binding var arraySelection: [Photo]
    @Binding var imageSelection: UIImage?

    let location: Location?

    @ViewBuilder let label: () -> Content

    @State private var showingImagePicker = false
    @State private var showingCamera = false

    var body: some View {
        Menu(content: imageButtons, label: label)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selection)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showingCamera) {
            Camera(image: $selection)
                .ignoresSafeArea()
        }
        .onChange(of: selection) { image in
            guard let image = image else { return }

            switch outputMethod {
            case .array:
                arraySelection.append(Photo(image: image, location: location ?? .example))
            case .atomic:
                atomicSelection = Photo(image: image, location: location ?? .example)
            case .image:
                imageSelection = selection
            }
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

    init(
        selection: Binding<Photo?>,
        location: Location,
        @ViewBuilder label: @escaping () -> Content
    ) {
        _arraySelection = .constant([])
        _atomicSelection = selection
        _imageSelection = .constant(nil)
        outputMethod = .atomic

        self.location = location
        self.label = label
    }

    init(
        selection: Binding<[Photo]>,
        location: Location,
        @ViewBuilder label: @escaping () -> Content
    ) {
        _arraySelection = selection
        _atomicSelection = .constant(nil)
        _imageSelection = .constant(nil)
        outputMethod = .array

        self.location = location
        self.label = label
    }

    init(
        selection: Binding<UIImage?>,
        @ViewBuilder label: @escaping () -> Content
    ) {
        _arraySelection = .constant([])
        _atomicSelection = .constant(nil)
        _imageSelection = selection
        outputMethod = .image

        self.location = nil
        self.label = label
    }

}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(selection: .constant(nil)) { EmptyView() }
    }
}
