//
//  LocationMapView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 23/07/22.
//

import MapKit
import SwiftUI

struct LocationMapView: View {
    @Binding var location: Location
    
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: location.locationCoordinates,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
    
    var body: some View {
        HStack {
            Button(action: openInMaps) {
                Map(coordinateRegion: .constant(region), annotationItems: [location]) {
                    MapMarker(coordinate: $0.locationCoordinates, tint: Color("AccentColor"))
                }
                .disabled(true)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .frame(width: 225, height: 225)
                .padding(.leading)
            }
            
            Divider()
        }
    }
    
    func openInMaps() {
        let mapItem = MKMapItem(location: location)
        mapItem.openInMaps()
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView(location: .constant(.example))
    }
}
