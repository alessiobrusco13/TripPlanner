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
    let label: () -> Content
    
    @State private var showingSheet = false
    
    init(imageSelection: Binding<UIImage?>, @ViewBuilder label: @escaping () -> Content) {
        _image = imageSelection
        _imageID = .constant(nil)
        self.label = label
    }
    
    init(idSelection: Binding<String?>, @ViewBuilder label: @escaping () -> Content) {
        _imageID = idSelection
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
            PhotoPicker(image: $image, identifier: $imageID)
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
