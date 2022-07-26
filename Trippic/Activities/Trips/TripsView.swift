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
    @State private var showingInfo = false
    @State private var showingDeleteConfirmation = false

    var body: some View {
        NavigationView {
            List(selection: $selectedTrips) {
                ForEach(dataController.trips.sorted()) { trip in
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
            .sheet(isPresented: $showingInfo, content: InfoView.init)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !dataController.trips.isEmpty {
                        EditButton()
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

                            Button {
                                showingDeleteConfirmation.toggle()
                            } label: {
                                Label("Delete Selection", systemImage: "trash")
                            }
                            .disabled(selectedTrips.isEmpty)
                        }
                    } else {
                        HStack {
                            Button  {
                                showingInfo.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                                    .font(.body.weight(.medium))
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .confirmationDialog(
                "Are you sure you want to permanently delete this trip?",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        dataController.trips.removeAll(where: selectedTrips.contains)
                        selectedTrips.removeAll()
                        editMode = .inactive
                    }
                }
            }
            .onChange(of: editMode) { _ in
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
