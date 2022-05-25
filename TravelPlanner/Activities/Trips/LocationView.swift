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
    
    var body: some View {
        VStack(alignment: .leading) {
            ImagesRowView(location: $location) { editAction in
                Button {
                    changingLocation.toggle()
                } label: {
                    Label("Change Location", systemImage: "mappin.and.ellipse")
                }

                if !location.images.isEmpty {
                    Button {
                        editAction()
                    } label: {
                        Label("Edit Photos", systemImage: "pencil")
                    }
                }

                Button(role: .destructive) {
                    showingDeleteConfirmation.toggle()
                } label: {
                    Label("Remove Location", systemImage: "trash")
                }

            }
            .frame(height: 250)

            LocationRowView(location: location)
                .padding(.horizontal, 30)

            Divider()
                .padding(.horizontal, 30)
        }
        .transition(.slide)
        .locationPicker(isPresented: $changingLocation, selection: $newLocation)
        .onChange(of: newLocation) { newValue in
            withAnimation {
                guard var newValue = newValue else { return }
                newValue.images = location.images
                location = newValue
            }
        }
        .confirmationDialog("Are you sure you want to permanently delete this location?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
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
