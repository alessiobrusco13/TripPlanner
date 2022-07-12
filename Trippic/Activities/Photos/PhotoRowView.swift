//
//  PhotoRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/07/22.
//

import SwiftUI

struct PhotoRowView: View {
    @Binding var photo: PhotoAsset
    
    var body: some View {
        HStack {
            PhotoView(asset: photo) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
            }
            
            Spacer()
            
            DatePicker("Cration Date", selection: $photo.creationDate)
                .labelsHidden()
            
            Spacer()
        }
        .tag(photo)
    }
}

struct PhotoRowView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRowView(photo: .constant(.example))
    }
}
