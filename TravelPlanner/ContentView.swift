//
//  ContentView.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataController: DataController

    @State private var selectedTrips = Set<Trip>()
    @State private var editMode = EditMode.inactive

    @State private var showingAdd = false

    var body: some View {
        List(selection: $selectedTrips) {
            ForEach(dataController.trips) { trip in
                NavigationLink {
                    TripView(trip: trip)
                } label: {
                    TripRowView(trip: trip)
                }
                .listRowSeparator(.hidden, edges: .all)
                .tag(trip)
            }
            .onDelete(perform: dataController.delete)
        }
        .listStyle(.plain)
        .animation(.default, value: dataController.trips)
        .overlay {
            if dataController.trips.isEmpty {
                Text("Create a trip tapping the \"+\" button.")
                    .font(.title3.italic())
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Trips")
        .sheet(isPresented: $showingAdd, content: NewTripView.init)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: EditButton.init)

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

                        Button(role: .destructive) {
                            dataController.delete(selectedTrips)
                            selectedTrips.removeAll()
                            editMode = .inactive
                        } label: {
                            Label("Delete selected", systemImage: "trash")
                        }
                        .disabled(selectedTrips.isEmpty)
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .onChange(of: editMode) { _ in
            guard selectedTrips.isEmpty == false else { return }
            selectedTrips.removeAll()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController())
    }
}
