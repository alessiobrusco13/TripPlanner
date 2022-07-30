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
    @State private var showingAdd = false
    @State private var showingInfo = false
    @State private var showingDeleteConfirmation = false
    
    @Environment(\.editMode) var editMode
    
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
            .animation(.default, value: selectedTrips)
            .overlay {
                if dataController.trips.isEmpty {
                    Text("There aren't any trips.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Trips")
            .sheet(isPresented: $showingAdd) {
                NewTripView()
            }
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
                        Label("Add Trip", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                        HStack {
                            if !selectedTrips.isEmpty {
                                Spacer()
                                    .transition(.scale)
                            }
                            
                            Button {
                                if selectedTrips.isEmpty {
                                    showingInfo.toggle()
                                } else {
                                    showingDeleteConfirmation.toggle()
                                }
                            } label: {
                                Label(
                                    selectedTrips.isEmpty ? "Info" : "Delete Selection",
                                    systemImage: selectedTrips.isEmpty ? "info.circle" : "trash"
                                )
                            }
                            
                            if selectedTrips.isEmpty {
                                Spacer()
                                    .transition(.scale)
                            }
                        }
                    }
            }
            .confirmationDialog(
                "Are you sure you want to permanently delete this trip?",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        dataController.trips.removeAll(where: selectedTrips.contains)
                        selectedTrips.removeAll()
                    }
                }
            }
            .onChange(of: editMode?.wrappedValue) { _ in
                selectedTrips.removeAll()
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
            .environmentObject(DataController())
    }
}
