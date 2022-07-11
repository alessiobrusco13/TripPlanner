//
//  FullscreenMapView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/07/22.
//

import MapKit
import SwiftUI

struct FullscreenMapView: View {
    @Binding var region: MKCoordinateRegion
    let locations: [Location]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { location in
            MapMarker(coordinate: location.locationCoordinates, tint: Color("AccentColor"))
        }
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            Button(action: dismiss.callAsFunction) {
                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.secondary)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct FullscreenMapView_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenMapView(region: .constant(.init()), locations: [.example])
    }
}
