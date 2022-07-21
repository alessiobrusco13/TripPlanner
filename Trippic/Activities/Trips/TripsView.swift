//
//  TripsView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 29/05/22.
//

import SwiftUI

struct TripsView: View {
    @EnvironmentObject private var dataController: DataController

    @State private var selectedTrips = Set<Trip>()
    @State private var editMode = EditMode.inactive
    @State private var showingAdd = false

    var body: some View {
        NavigationView {
            List(selection: $selectedTrips) {
                ForEach(dataController.trips) { trip in
                    TripRowView(trip: trip)
                        .tag(trip)
                }
                .onDelete(perform: dataController.delete)
                .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
            }
            .listStyle(.plain)
            .animation(.default, value: dataController.trips)
            .overlay {
                if dataController.trips.isEmpty {
                    Text("There aren't any trips.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Trips")
            .sheet(isPresented: $showingAdd, content: NewTripView.init)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !dataController.trips.isEmpty {
                        EditButton()
                            .frame(width: 32)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAdd.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    if editMode == .active {
                        HStack {
                            Spacer()

                            DeleteButton(data: $dataController.trips, selection: $selectedTrips)
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(.stack)
    }
}

struct TripsView_Previews: PreviewProvider {
        static var previews: some View {
            TripsView()
                .environmentObject(DataController())
        }
}
