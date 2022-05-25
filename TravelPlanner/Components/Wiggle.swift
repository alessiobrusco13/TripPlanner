//
//  Wiggle.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 25/05/22.
//

import SwiftUI

extension View {
    func wiggle(enabled: Binding<Bool>, isWiggling: Binding<Bool>) -> some View {
        modifier(WiggleModifier(enabled: enabled, isWiggling: isWiggling))
    }
}

struct WiggleModifier: ViewModifier {
    @Binding var enabled: Bool
    @Binding var isWiggling: Bool

    private static func randomize(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }

    private let rotateAnimation = Animation.easeInOut(
        duration: WiggleModifier.randomize(
            interval: 0.14,
            withVariance: 0.025
        )
    )
        .repeatForever(autoreverses: true)

    private let bounceAnimation = Animation.easeInOut(
        duration: WiggleModifier.randomize(
            interval: 0.18,
            withVariance: 0.025
        )
    )
        .repeatForever(autoreverses: true)

    func body(content: Content) -> some View {
        content
            .rotationEffect(enabled ? .degrees(isWiggling ? 2.0 : 0) : .zero)
            .animation(rotateAnimation, value: isWiggling)
            .offset(x: 0, y: enabled ? (isWiggling ? 2.0 : 0) : 0)
            .animation(bounceAnimation, value: isWiggling)
            .onAppear {
                isWiggling.toggle()
            }
            .onChange(of: enabled) { newValue in
                isWiggling = newValue
            }
    }
}
