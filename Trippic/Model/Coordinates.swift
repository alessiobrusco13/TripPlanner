//
//  Coordinates.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import Foundation
import MapKit

struct Coordinates: Codable, Sendable {
    let longitude: Double
    let latitude: Double
}

extension Coordinates {
    init(clLocationCoordinate2D: CLLocationCoordinate2D) {
        longitude = clLocationCoordinate2D.longitude
        latitude = clLocationCoordinate2D.latitude
    }
}
