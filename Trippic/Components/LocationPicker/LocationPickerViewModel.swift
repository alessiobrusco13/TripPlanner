//
//  LocationPickerViewModel.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/05/22.
//

import Combine
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
                    search()
                }
            }
        }
        
        private func search() {
            let request = MKLocalSearch.Request()
            request.pointOfInterestFilter = .includingAll
            request.naturalLanguageQuery = searchText
            
            let search = MKLocalSearch(request: request)
            search.start { [weak self] response, error in
                guard let response else { return }
                self?.locations = response.mapItems.map(Location.init)
            }
        }
        
        var isLoading: Bool {
            locations.isEmpty && !searchText.isEmpty
        }
    }
}
