//
//  ImagesGridView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 26/05/22.
//

import SwiftUI

struct ImagesGridView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button("Dismiss") {
            dismiss()
        }
    }
}

struct ImagesGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesGridView()
    }
}
