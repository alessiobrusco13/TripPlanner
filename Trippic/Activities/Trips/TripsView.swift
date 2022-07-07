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
                    NavigationLink {
                        TripView(trip: trip)
                            .environmentObject(dataController)
                    } label: {
                        TripRowView(trip: trip)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    .tag(trip)
                }
                .onDelete {
                    dataController.delete($0)
                }
                .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 10))
            }
            .listStyle(.plain)
            .animation(.default, value: dataController.trips)
            .overlay {
                if dataController.trips.isEmpty {
                    Text("Create a trip tapping the + button.")
                        .font(.title3.italic())
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Trips")
            .sheet(isPresented: $showingAdd) {
                NewTripView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: EditButton.init)

                ToolbarItem(placement: .navigationBarTrailing) {
                    CircleButton(systemImage: "plus") {
                        showingAdd.toggle()
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
        .navigationViewStyle(.stack)
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
            .environmentObject(DataController())
    }
}
