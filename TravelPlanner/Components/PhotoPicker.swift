//
//  PhotoPicker.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 18/05/22.
//

import SwiftUI

struct PhotoPicker<Content: View>: View {
    private enum OutputMethod {
        case array, atomic
    }

    private let outputMethod: OutputMethod
    @State private var selection: UIImage?

    @Binding var atomicSelection: UIImage?
    @Binding var arraySelection: [UIImage]

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

            if outputMethod == .atomic {
                atomicSelection = image
            } else {
                arraySelection.append(image)
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
            showingImagePicker.toggle()
            #else
            showingCamera.toggle()
            #endif
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }

    init(
        selection: Binding<UIImage?>,
        @ViewBuilder label: @escaping () -> Content
    ) {
        _arraySelection = .constant([])
        _atomicSelection = selection
        outputMethod = .atomic

        self.label = label
    }

    init(
        selection: Binding<[UIImage]>,
        @ViewBuilder label: @escaping () -> Content
    ) {
        _arraySelection = selection
        _atomicSelection = .constant(nil)
        outputMethod = .array

        self.label = label
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(selection: .constant(nil)) { EmptyView() }
    }
}
