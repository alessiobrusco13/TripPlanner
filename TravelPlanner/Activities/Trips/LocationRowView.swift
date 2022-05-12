//
//  LocationRowView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 11/05/22.
//

import SwiftUI

struct LocationRowView: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.title2.weight(.medium))

            Text(location.extendedName)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
    }
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(location: Location.example)
    }
}
