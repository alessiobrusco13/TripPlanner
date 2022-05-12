//
//  ImageDeck.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import SwiftUI

struct ImageDeck: View {
    @State private var images: [Image]

    var body: some View {
        ZStack {
            ForEach(0..<images.count, id: \.self) { index in
                DeckImageView(image: images[index]) {
                    removeImage(at: index)
                }
                .stacked(at: index, in: images.count)
            }
        }
    }

    init(images: [Image]) {
        self.images = images
    }

    init(uiImages: [UIImage]) {
        let converted = uiImages.map(Image.init)
        images = converted
    }

    func removeImage(at index: Int) {
        withAnimation {
            let image = images.popLast() ?? .init("Example1")
            images.append(image)
        }
    }
}

struct ImageDeck_Previews: PreviewProvider {
    static var previews: some View {
        ImageDeck(images: [
            Image("Example1"),
            Image("Example2"),
            Image("Example3"),
            Image("Example4"),
            Image("Example5")
        ])
    }
}
