//
//  LocationView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import MapKit
import SwiftUI

struct LocationView: View {
    @ObservedObject var location: Location
    @ObservedObject var trip: Trip

    @State private var changingLocation = false
    @State private var newLocation: Location?

    @State private var showingDeleteConfirmation = false
    @State private var showingImageGrid = false

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            PhotosRowView(location: location) { editAction in
                Button(role: .destructive) {
                    showingDeleteConfirmation.toggle()
                } label: {
                    Label("Remove Location", systemImage: "trash")
                }

                Button {
                    changingLocation.toggle()
                } label: {
                    Label("Change Location", systemImage: "mappin.and.ellipse")
                }

                if !location.photos.isEmpty {
                    Button {
                        editAction()
                    } label: {
                        Label("Edit Photos", systemImage: "pencil")
                    }

                    Button {
                        showingImageGrid.toggle()
                    } label: {
                        Label("Show Grid", systemImage: "square.grid.2x2")
                    }
                }
            }
            .frame(height: 250)

            LocationRowView(location: location)
                .padding(.horizontal)

            Divider()
                .padding(.horizontal)
        }
        .transition(.slide)
        .locationPicker(isPresented: $changingLocation, selection: $newLocation) { location in
            
        }
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
        .fullScreenCover(isPresented: $showingImageGrid) {
            PhotosGridView(photos: $location.photos)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: .example, trip: .example)
            .environmentObject(DataController())
    }
}
