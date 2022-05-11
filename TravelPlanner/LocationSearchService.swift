//
//  LocationSearchService.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 11/05/22.
//

import Combine
import MapKit

class LocationSearchService {
    let locationSearchPublisher = PassthroughSubject<[MKMapItem], Never>()

    func search(
        searchText: String
    ) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = .includingAll

        let search = MKLocalSearch(request: request)

        search.start { [weak self] response, error in
            guard let response = response else {
                print((error as? MKError)?.code ?? .unknown)
                return
            }

            self?.locationSearchPublisher
                .send(response.mapItems)
        }
    }
}
