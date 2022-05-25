//
//  TripView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 04/05/22.
//

import SwiftUI
import MapKit

struct TripView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var dataController: DataController
    @ObservedObject var trip: Trip

    @State private var showingLocationPicker = false
    @State private var region = MKCoordinateRegion()

    @FocusState private var editingName: Bool
    @State private var editingTrip = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    Map(coordinateRegion: $region, annotationItems: trip.locations) { location in
                        MapMarker(coordinate: location.locationCoordinates, tint: .accentColor)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)

                    CircleImage(uiImage: trip.image)
                        .frame(height: 200)
                        .padding(.top, -175)
                        .padding(.bottom)

                    VStack {
                        TextField("Enter trip name", text: $trip.name)
                            .disabled(!editingTrip)
                            .focused($editingName)
                            .font(.largeTitle.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .onSubmit {
                                editingName = false
                            }

                        HStack(spacing: 5) {
                            Text(trip.startDate, format: .dateTime.day().month())

                            Image(systemName: "arrow.right")
                                .font(.caption.weight(.heavy))

                            Text(trip.endDate, format: .dateTime.day().month())
                        }

                        Divider()
                            .padding(.horizontal)
                    }

                    ForEach($trip.locations) {
                        LocationView(location: $0, trip: trip)
                    }

                    Color.clear
                        .frame(height: 100)

                    Spacer()
                }
            }
        }
        .locationPicker(isPresented: $showingLocationPicker, selection: $trip.locations)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Menu {
                        Button {
                            withAnimation {
                                editingTrip = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                editingName = true
                            }
                        } label: {
                            Label("Edit Trip", systemImage: "pencil")
                        }

                        Button(role: .destructive) {
                            dataController.delete(trip)
                            dismiss()
                        } label: {
                            Label("Remove Trip", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: editingTrip ? "checkmark" : "ellipsis")
                            .font(.headline)
                            .padding(editingTrip ? 6 : 14)
                            .background {
                                Circle()
                                    .opacity(0.2)
                            }
                    } primaryAction: {
                        if editingTrip {
                            editingName = false
                            editingTrip = false
                        }
                    }

                    CircleButton(systemImage: "doc.badge.plus") {
                        showingLocationPicker.toggle()
                    }
                }
            }
        }
        .onAppear(perform: setRegion)
        .onDisappear(perform: dataController.save)
        .onChange(of: trip.locations) { _ in
            setRegion()
        }
    }

    private func setRegion() {
        withAnimation {
            region = MKCoordinateRegion(
                center: trip.locations.map(\.locationCoordinates).center,
                latitudinalMeters: 20_000,
                longitudinalMeters: 20_000
            )
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripView(trip: .example)
                .environmentObject(DataController())
        }
    }
}
