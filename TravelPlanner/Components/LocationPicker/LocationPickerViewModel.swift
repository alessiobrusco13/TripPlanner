//
//  LocationPickerViewModel.swift
//  TravelPlanner
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

    class ViewModel: ObservableObject {
        private var locationsSubscription: AnyCancellable?
        private let searchService = LocationSearchService()

        @Published var locations = [Location]()
        @Published var errorCode: MKError.Code?

        @Published var searchText = "" {
            didSet { search() }
        }

        var isLoading: Bool {
            locations.isEmpty && !searchText.isEmpty
        }

        init() {
            locationsSubscription = searchService.locationSearchPublisher
                .sink() { [weak self] mapItems in
                    self?.locations = mapItems.map(Location.init)
                }
        }

        private func search() {
            locations = []
            searchService.search(searchText: searchText)
        }
    }
}
