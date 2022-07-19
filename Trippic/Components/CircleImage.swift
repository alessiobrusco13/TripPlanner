//
//  CircleImage.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 23/05/22.
//

import SwiftUI

struct CircleImage: View {
    let image: Image

    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color(.systemBackground), lineWidth: 4)
            }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image(uiImage: [UIImage].example[0]))
    }
}
