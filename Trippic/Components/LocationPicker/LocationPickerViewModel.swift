//
//  LocationPickerViewModel.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/05/22.
//

import Foundation
import MapKit

extension LocationPicker {
    enum SearchSetting {
        case searchForPointsOfInterest, searchForCities
    }
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var locations = [Location]()
        @Published var searchText = "" {
            didSet {
                Task {
                    try await Task.sleep(nanoseconds: 1_000_000)
                    locations = try await results()
                }
            }
        }
        
        var isLoading: Bool {
            locations.isEmpty && !searchText.isEmpty
        }
        
        private func results() async throws -> [Location] {
            let request = MKLocalSearch.Request()
            request.pointOfInterestFilter = .includingAll
            request.naturalLanguageQuery = searchText
            
            let search = MKLocalSearch(request: request)
            return try await search.start().mapItems.map(Location.init)
        }
    }
}
