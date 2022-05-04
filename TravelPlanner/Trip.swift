//
//  Trip.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

class Trip: ObservableObject, Identifiable, Codable, Hashable {
    enum CodingKeys: CodingKey {
        case name, startDate, endDate, image, locations
    }

    let id = UUID()

    @Published var name = ""
    @Published var startDate = Date.now
    @Published var endDate = Date.now.addingTimeInterval(1*60*60*24)
    @Published var image = UIImage(named: "Example")!
    @Published var locations = [Location]()

    static let example: Trip = {
        let trip = Trip()
        trip.name = "New Trip"
        return trip
    }()

    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }

    init() {
        locations.append(Location())
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(UIImage.self, forKey: .image)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        locations = try container.decode([Location].self, forKey: .locations)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(image, forKey: .image)
        try container.encode(locations, forKey: .locations)
    }
}
