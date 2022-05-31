//
//  Location.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI
import MapKit

class Location: ObservableObject, Identifiable, Codable, Hashable {
    enum CodingKeys: CodingKey {
        case id, name, extendedName, coordinates, photos
    }

    let id: UUID
    @Published var name: String
    @Published var extendedName: String
    @Published var coordinates: Coordinates
    @Published var photos: [Photo]

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
        photos: [Photo]
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

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.extendedName = try container.decode(String.self, forKey: .extendedName)
        self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        self.photos = try container.decode([Photo].self, forKey: .photos)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(extendedName, forKey: .extendedName)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(photos, forKey: .photos)
    }

    func delete(_ photo: Photo) {
        guard let index = photos.firstIndex(of: photo) else { return }
        photos.remove(at: index)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func update(location: Location) {
        name = location.name
        extendedName = location.extendedName
        coordinates = location.coordinates
    }
}
