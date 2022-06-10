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

    @State private var changingLocation = false
    @State private var newLocation: Location?

    @State private var showingDeleteConfirmation = false
    @State private var showingImageGrid = false

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LocationRowView(location: $location)
                .padding(.horizontal)
            
            PhotosRowView(location: $location) {
                Button(role: .destructive) {
                    showingDeleteConfirmation.toggle()
                } label: {
                    Label("Remove Location", systemImage: "trash")
                }
                
                Divider()

                Button {
                    changingLocation.toggle()
                } label: {
                    Label("Change Location", systemImage: "mappin.and.ellipse")
                }
                
                NavigationLink {
                    PhotosGridView(photos: $location.photos)
                } label: {
                    Label("Edit Photos", systemImage: "pencil")
                }
            }
        }
        .transition(.slide)
        .locationPicker(isPresented: $changingLocation, selection: $newLocation)
        .onChange(of: newLocation) { newValue in
            withAnimation {
                guard let newValue = newValue else { return }
                location.update(location: newValue)
            }
        }
        .confirmationDialog(
            "Are you sure you want to permanently delete this location?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    trip.delete(location)
                }
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: .constant(.example), trip: .example)
            .environmentObject(DataController())
    }
}
