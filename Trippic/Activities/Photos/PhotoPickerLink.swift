//
//  PhotoPickerLink.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 23/06/22.
//

import SwiftUI

struct PhotoPickerLink<Content: View>: View {
    @Binding var image: UIImage?
    @Binding var imageID: String?
    @Binding var photoAsset: PhotoAsset
    let label: () -> Content
    
    @State private var showingSheet = false
    
    init(imageSelection: Binding<UIImage?>, @ViewBuilder label: @escaping () -> Content) {
        _image = imageSelection
        _imageID = .constant(nil)
        _photoAsset = .constant(.example)
        self.label = label
    }
    
    init(idSelection: Binding<String?>, @ViewBuilder label: @escaping () -> Content) {
        _imageID = idSelection
        _image = .constant(nil)
        _photoAsset = .constant(.example)
        self.label = label
    }
    
    init(assetSelection: Binding<PhotoAsset>, @ViewBuilder label: @escaping () -> Content) {
        _photoAsset = assetSelection
        _imageID = .constant(nil)
        _image = .constant(nil)
        self.label = label
    }
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            label()
        }
        .sheet(isPresented: $showingSheet) {
            PhotoPicker(image: $image, identifier: $imageID, asset: $photoAsset)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct PhotoPickerLink_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerLink(imageSelection: .constant(.init())) {
            Text("hello")
        }
    }
}
