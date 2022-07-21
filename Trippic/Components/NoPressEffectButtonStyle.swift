//
//  PassthroughButtonStyle.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import SwiftUI

struct NoPressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension ButtonStyle where Self == NoPressEffectButtonStyle {
    static var noPressEffect: NoPressEffectButtonStyle {
        NoPressEffectButtonStyle()
    }
}

struct PassthroughButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: { print("Pressed") }) {
            Label(String("Press Me"), systemImage: "star")
        }
        .buttonStyle(NoPressEffectButtonStyle())
    }
}
