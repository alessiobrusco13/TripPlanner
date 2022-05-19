//
//  Location.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI
import MapKit

struct Location: Identifiable, Codable, Hashable {
    enum CodingKeys: CodingKey {
        case id, name, extendedName, coordinates, images
    }

    let id: UUID
    let name: String
    let extendedName: String
    let coordinates: Coordinates
    var images: [UIImage]

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
        images: .example
    )
}

extension Location {
    init(mapItem: MKMapItem) {
        id = UUID()
        name = mapItem.name ?? "N/A"
        extendedName = mapItem.placemark.title ?? "N/A"
        coordinates =  Coordinates(clLocationCoordinate2D: mapItem.placemark.coordinate)
        images = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.extendedName = try container.decode(String.self, forKey: .extendedName)
        self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        self.images = try container.decode([UIImage].self, forKey: .images)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(extendedName, forKey: .extendedName)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(images, forKey: .images)
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

