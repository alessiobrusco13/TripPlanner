//
//  MKMapItem-Location.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/07/22.
//

import MapKit

extension MKMapItem {
    convenience init(location: Location) {
        let placemark = MKPlacemark(coordinate: location.locationCoordinates)
        self.init(placemark: placemark)
        
        name = location.name
    }
}
