//
//  LocationView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import SwiftUI

struct LocationView: View {
    @Binding var location: Location
    
    var body: some View {
        VStack(alignment: .leading) {
            ImagesRowView(images: $location.images)
                .frame(height: 200)

            LocationRowView(location: location)
                .padding(.horizontal)

            Divider()
                .padding(.horizontal)
        }

    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: .constant(.example))
    }
}
