//
//  LocationView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import MapKit
import SwiftUI

struct LocationView: View {
    @Binding var location: Location
    @ObservedObject var trip: Trip

    @State private var showingImageGrid = false
    @State private var gridNavigationLink = false

    @State private var editMode = EditMode.inactive
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LocationInfoView(location: $location, navigationLinkActive: $gridNavigationLink)
                .padding(.horizontal)
            
            LocationRowView(trip: trip, location: $location)
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
