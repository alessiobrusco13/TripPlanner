//
//  Trip.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

class Trip: ObservableObject, Identifiable, Codable, Hashable {
    enum CodingKeys: CodingKey {
        case name, startDate, endDate, photo, locations
    }

    let id = UUID()

    @Published var name = ""
    @Published var startDate = Date.now
    @Published var endDate = Date.now.addingTimeInterval(1*60*60*24)
    @Published var photo = PhotoAsset.example
    @Published var locations = [Location]()
    
    var allPhotos: [PhotoAsset] {
        Array(
            locations
                .map(\.photos)
                .joined()
        )
    }

    static let example: Trip = {
        let trip = Trip()
        trip.name = "New Trip"
        trip.locations = [.example]
        return trip
    }()

    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try decodeData(container: container)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try encodeData(container: &container)
    }
    
    private func encodeData(container: inout KeyedEncodingContainer<Trip.CodingKeys>) throws {
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(photo, forKey: .photo)
        try container.encode(locations, forKey: .locations)
    }
    
    private func decodeData(container: KeyedDecodingContainer<Trip.CodingKeys>) throws {
        name = try container.decode(String.self, forKey: .name)
        photo = try container.decode(PhotoAsset.self, forKey: .photo)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        locations = try container.decode([Location].self, forKey: .locations)
    }

    @MainActor
    func delete(_ location: Location) {
        guard let index = locations.firstIndex(of: location) else { return }
        locations.remove(at: index)
    }
    
    @MainActor
    func append(_ location: Location) {
        locations.append(location)
    }
}
