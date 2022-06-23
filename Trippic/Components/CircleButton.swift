//
//  CircleButton.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/05/22.
//

import SwiftUI

struct CircleButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.body.weight(.semibold))
        }
        .buttonStyle(.bordered)
        .tint(.accentColor)
        .clipShape(Circle())
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(systemImage: "plus") { }
    }
}
