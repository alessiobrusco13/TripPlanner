//
//  DeckImageView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import SwiftUI

struct DeckImageView: View {
    @State private var offset = CGSize.zero
    let image: Image
    var onRemove: (() -> Void)?

    var geasture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
            }
            .onEnded { _ in
                if abs(offset.width) > 100 {
                    onRemove?()
                } else {
                    offset = .zero
                }
            }
    }

    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(maxWidth: 300, maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 10).rotationEffect(.degrees(Double(offset.width / 5)))
            .offset(x: offset.width * 5, y: 0)
//            .opacity(2 - Double(abs(offset.width / 50)))
            .gesture(geasture)
            .animation(.spring(), value: offset)
    }
}
