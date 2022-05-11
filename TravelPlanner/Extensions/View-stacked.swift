//
//  View-stacked.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        guard position != total / 2 else { return self.offset() }

        let delta = Double(total - position)
        return self.offset(x: -(delta * 10), y: delta * 3)
    }
}
