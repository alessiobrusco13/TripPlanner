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
        
        init(trip: Trip) {
            self.trip = trip
        }
        
        func setRegion() {
            if trip.locations.isEmpty {
                Task { @MainActor in
                    miniMapRegion = try await guessedRegion(meters: 30_000)
                }
            } else {
                miniMapRegion = MKCoordinateRegion(
                    center: trip.locations.map(\.locationCoordinates).center,
                    latitudinalMeters: 20_000,
                    longitudinalMeters: 20_000
                )
            }
        }
        
        func zoomInMiniMap() {
            miniMapRegion.span.longitudeDelta *= 0.7
            miniMapRegion.span.latitudeDelta *= 0.7
        }
        
        func zoomOutMiniMap() {
            miniMapRegion.span.longitudeDelta *= 1.7
            miniMapRegion.span.latitudeDelta *= 1.7
        }
        
        private func guessedRegion(meters: Double) async throws -> MKCoordinateRegion {
            guard let center = try await CLGeocoder().geocodeAddressString(trip.name).first?.location?.coordinate else {
                throw CLError(.geocodeFoundNoResult)
            }
            
            return MKCoordinateRegion(
                center: center,
                latitudinalMeters: meters,
                longitudinalMeters: meters
            )
        }
        
        private func updateRegions() {
            if showingFullscreenMap {
                fullscreenMapRegion = miniMapRegion
            }
        }
    }
}
