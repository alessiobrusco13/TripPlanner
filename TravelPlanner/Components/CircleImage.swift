//
//  CircleImage.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 23/05/22.
//

import SwiftUI

struct CircleImage: View {
    let uiImage: UIImage

    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(uiImage: [UIImage].example[0])
    }
}
