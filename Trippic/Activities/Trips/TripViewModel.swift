//
//  TripViewModel.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 05/07/22.
//

import MapKit

extension TripView {
    class ViewModel: ObservableObject {
        @Published var region = MKCoordinateRegion()
        @Published var trip: Trip
        @Published var newLocation: Location?
        
        init(trip: Trip) {
            self.trip = trip
        }
        
        func setRegion() {
            if trip.locations.isEmpty {
                Task { @MainActor in
                    region = try await guessedRegion(meters: 30_000)
                }
            } else {
                region = MKCoordinateRegion(
                    center: trip.locations.map(\.locationCoordinates).center,
                    latitudinalMeters: 20_000,
                    longitudinalMeters: 20_000
                )
            }
        }
        
        func scaleUpRegion() {
            region.span.latitudeDelta /= 2
            region.span.longitudeDelta /= 2
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
    }
}
