//
//  Location.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import MapKit
import SwiftUI

struct Location: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var name: String
    var extendedName: String
    var coordinates: Coordinates
    var photos: [PhotoAsset]

    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
    }

    static let example = Location(
        id: UUID(),
        name: "London",
        extendedName: "London, England, United Kingdom",
        coordinates: Coordinates(longitude: 12.4963655, latitude: 41.9027835),
        photos: .example
    )

    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    init(
        id: UUID,
        name: String,
        extendedName: String,
        coordinates: Coordinates,
        photos: [PhotoAsset]
    ) {
        self.id = id
        self.name = name
        self.extendedName = extendedName
        self.coordinates = coordinates
        self.photos = photos
    }

    init(mapItem: MKMapItem) {
        id = UUID()
        name = mapItem.name ?? "N/A"
        extendedName = mapItem.placemark.title ?? "N/A"
        coordinates = Coordinates(clLocationCoordinate2D: mapItem.placemark.coordinate)
        photos = []
    }

    mutating func delete(_ photo: PhotoAsset) {
        guard let index = photos.firstIndex(of: photo) else { return }
        photos.remove(at: index)
    }
    
    mutating func delete(_ offsets: IndexSet) {
        photos.remove(atOffsets: offsets)
    }
    
    mutating func delete(_ selected: Set<PhotoAsset>) {
        photos.removeAll(where: selected.contains)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    mutating func update(location: Location) {
        name = location.name
        extendedName = location.extendedName
        coordinates = location.coordinates
    }
}
