//
//  Location.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI
import MapKit

struct Location: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id, name, coordinates, image
    }

    let id: UUID
    var name: String
    var coordinates: Coordinates
    var image: UIImage

    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
    }

    init() {
        id = UUID()
        name = "New Location"
        coordinates = Coordinates(longitude: 12.4963655, latitude: 41.9027835)
        image = UIImage(systemName: "questionmark")!
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        self.image = try container.decode(UIImage.self, forKey: .image)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(image, forKey: .image, quality: .png)
    }
}

