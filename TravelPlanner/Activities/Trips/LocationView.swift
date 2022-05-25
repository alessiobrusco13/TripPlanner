//
//  LocationView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import MapKit
import SwiftUI

struct LocationView: View {
    @Binding var location: Location
    @ObservedObject var trip: Trip
    
    var body: some View {
        VStack(alignment: .leading) {
            ImagesRowView(location: $location) {
                Button(role: .destructive) {
                    withAnimation {
                        trip.delete(location)
                    }
                } label: {
                    Label("Remove Location", systemImage: "trash")
                }
            }
            .frame(height: 200)

            LocationRowView(location: location)
                .padding(.horizontal, 30)

            Divider()
                .padding(.horizontal, 30)
        }
        .transition(.slide)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: .constant(.example), trip: .example)
            .environmentObject(DataController())
    }
}
