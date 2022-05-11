//
//  TripView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 04/05/22.
//

import SwiftUI

struct TripView: View {
    @ObservedObject var trip: Trip
    @State private var showingLocationPicker = false


    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                ForEach($trip.locations, content: LocationView.init)
            }
        }
        .locationPicker(isPresented: $showingLocationPicker, selection: $trip.locations)
        .toolbar {
            Button("Add") {
                showingLocationPicker.toggle()
            }
        }
        .navigationTitle(trip.name)
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripView(trip: .example)
        }
    }
}
