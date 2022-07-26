//
//  TripViewModel.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 05/07/22.
//

import MapKit

extension TripView {
    class ViewModel: ObservableObject {
        @Published var miniMapRegion = MKCoordinateRegion()
        @Published var fullscreenMapRegion = MKCoordinateRegion()
        
        @Published var showingFullscreenMap = false {
            didSet { updateRegions() }
        }
        
        @Published var trip: Trip
        @Published var newLocation: Location?
        
        @Published var startDate: Date {
            didSet {
                if startDate > endDate {
                    endDate = startDate.addingTimeInterval(1*60*60*24)
                }
            }
        }
        
        @Published var endDate: Date
        
        init(trip: Trip) {
            self.trip = trip
            startDate = trip.startDate
            endDate = trip.endDate
        }
        
        func setRegion() {
            if trip.locations.isEmpty {
                Task { @MainActor in
                    miniMapRegion = try await guessedRegion(meters: 30_000)
                }
            } else {
                if let delta = trip.mapDelta {
                    miniMapRegion = MKCoordinateRegion(
                        center: trip.locations.map(\.locationCoordinates).center,
                        span: MKCoordinateSpan(latitudeDelta: delta.latitude, longitudeDelta: delta.longitude)
                    )
                    
                } else {
                    miniMapRegion = MKCoordinateRegion(
                        center: trip.locations.map(\.locationCoordinates).center,
                        latitudinalMeters: 20_000,
                        longitudinalMeters: 20_000
                    )
                }
            }
        }
        
        private func updateDelta() {
            let span = miniMapRegion.span
            trip.mapDelta = Coordinates(longitude: span.longitudeDelta, latitude: span.latitudeDelta)
        }
        
        private func updateDates() {
            trip.startDate = startDate
            trip.endDate = endDate
        }
        
        func updateTrip() {
            updateDates()
            updateDelta()
        }
        
        func zoomInMiniMap() {
            miniMapRegion.span.longitudeDelta *= 0.8
            miniMapRegion.span.latitudeDelta *= 0.8
        }
        
        func zoomOutMiniMap() {
            miniMapRegion.span.longitudeDelta *= 1.8
            miniMapRegion.span.latitudeDelta *= 1.8
        }
        
        private func guessedRegion(meters: Double) async throws -> MKCoordinateRegion {
            guard let center = try await CLGeocoder().geocodeAddressString(trip.name).first?.location?.coordinate else {
                throw CLError(.geocodeFoundNoResult)
            }
            
            if let delta = trip.mapDelta {
                return MKCoordinateRegion(
                    center: center,
                    span: MKCoordinateSpan(latitudeDelta: delta.latitude, longitudeDelta: delta.longitude)
                )
            } else {
                return MKCoordinateRegion(
                    center: center,
                    latitudinalMeters: meters,
                    longitudinalMeters: meters
                )
            }
        }
        
        func updateRegions() {
            if showingFullscreenMap {
                fullscreenMapRegion = miniMapRegion
            }
        }
    }
}
