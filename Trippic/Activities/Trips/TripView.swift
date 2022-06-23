//
//  TripView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 04/05/22.
//

import MapKit
import SwiftUI

struct TripView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var dataController: DataController
    @ObservedObject var trip: Trip
    
    @State private var showingLocationPicker = false
    @State private var region = MKCoordinateRegion()
    
    @FocusState private var editingName: Bool
    @State private var editingTrip = false
    @State private var newImage: UIImage?
    
    @State private var newLocation: Location?
    
    init(trip: Trip) {
        self.trip = trip
        setRegion()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Map(coordinateRegion: $region, annotationItems: trip.locations) { location in
                    MapMarker(coordinate: location.locationCoordinates, tint: .accentColor)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                
                CircleImage(uiImage: trip.image)
                    .frame(maxWidth: 350)
                    .frame(height: 350)
                    .padding(.top, -175)
                    .overlay {
                        if editingTrip {
                            PhotoPicker(selection: $newImage) {
                                Image(systemName: "photo.fill.on.rectangle.fill")
                                    .font(.largeTitle)
                                    .contentShape(Rectangle())
                            }
                            .padding()
                            .background()
                            .cornerRadius(10)
                            .transition(.scale)
                        }
                    }
                
                VStack {
                    if !editingTrip {
                        Text(trip.name)
                            .font(.largeTitle.weight(.semibold))
                    } else {
                        HStack {
                            TextField("Enter trip name", text: $trip.name)
                                .focused($editingName)
                                .font(.largeTitle.weight(.semibold))
                                .multilineTextAlignment(.center)
                                .onSubmit {
                                    editingName = false
                                }
                                .textFieldStyle(.roundedBorder)
                                .overlay(alignment: .trailing) {
                                    Button("Done") {
                                        withAnimation {
                                            editingTrip = false
                                        }
                                    }
                                    .font(.title3.weight(.bold))
                                    .padding()
                                }
                        }
                        .frame(maxWidth: 364)
                    }
                    
                    HStack(spacing: 5) {
                        if !editingTrip {
                            Text(trip.startDate, format: .dateTime.day().month())
                        } else {
                            DatePicker(
                                "Start date",
                                selection: $trip.startDate,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                        }
                        
                        Image(systemName: "arrow.right")
                            .font(.caption.weight(.heavy))
                        
                        if !editingTrip {
                            Text(trip.endDate, format: .dateTime.day().month())
                        } else {
                            DatePicker(
                                "End date",
                                selection: $trip.endDate,
                                in: trip.startDate...,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                        }
                    }
                    .padding(editingTrip ? 8 : 0)
                }
                
                ForEach($trip.locations) {
                    LocationView(location: $0, trip: trip)
                }
                
                Color.clear
                    .frame(height: 100)
                
                Spacer()
            }
        }
        .locationPicker(isPresented: $showingLocationPicker, selection: $newLocation)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Menu {
                        Button {
                            withAnimation {
                                editingTrip = true
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
                        Image(systemName: "ellipsis")
                            .font(.headline)
                            .padding(14)
                            .background {
                                Circle()
                                    .opacity(0.2)
                            }
                    }
                    
                    CircleButton(systemImage: "doc.badge.plus") {
                        showingLocationPicker.toggle()
                    }
                }
            }
        }
        .onChange(of: trip.locations) { _ in
            setRegion()
        }
        .onChange(of: newImage) { image in
            guard let image = image else { return }
            
            withAnimation {
                trip.image = image
            }
        }
        .onChange(of: newLocation) { location in
            guard let location =  location else { return }
            
            withAnimation {
                trip.append(location)
            }
        }
        .task {
            await dataController.photoCollection.cache.startCaching(for: trip.allPhotos, targetSize: CGSize(width: 550, height: 550))
        }
        .onDisappear {
            Task {
                await dataController.photoCollection.cache.stopCaching()
            }
        }
    }
    
    @Sendable private func setRegion() {
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
