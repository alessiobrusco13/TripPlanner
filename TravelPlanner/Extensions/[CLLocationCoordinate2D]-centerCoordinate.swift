//
//  [Coordinates]-centerCoordinate.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import MapKit

extension Array where Element == CLLocationCoordinate2D {
    var center: CLLocationCoordinate2D {
        guard !isEmpty else {
            return CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)
        }

        let lat = map(\.latitude).reduce(0, +) / Double(count)
        let long = map(\.longitude).reduce(0, +) / Double(count)
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
