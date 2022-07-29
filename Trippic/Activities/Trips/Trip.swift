//
//  Trip.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

class Trip: ObservableObject, Identifiable, Codable, Hashable, Comparable {
    enum CodingKeys: CodingKey {
        case name, startDate, endDate, photo, locations, notes, mapDelta
    }

    let id = UUID()

    @Published var name: String
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var photo: PhotoAsset
    @Published var locations = [Location]()
    @Published var notes = [Note]()
    @Published var mapDelta: Coordinates?
    
    var allPhotos: [PhotoAsset] {
        Array(
            locations
                .map(\.photos)
                .joined()
        )
    }

    static let example: Trip = {
        let trip = Trip(photo: .example)
        trip.name = "New Trip"
        trip.locations = [.example]
        return trip
    }()

    static func ==(lhs: Trip, rhs: Trip) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Trip, rhs: Trip) -> Bool {
        lhs.startDate > rhs.startDate
    }

    init(photo: PhotoAsset) {
        name = ""
        startDate = Date.now
        endDate = Date.now.addingTimeInterval(1*60*60*24)
        self.photo = photo
    }
    
    init(name: String, startDate: Date, endDate: Date, assetID: String) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        photo = PhotoAsset(identifier: assetID)
    }
    

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        photo = try container.decode(PhotoAsset.self, forKey: .photo)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        locations = try container.decode([Location].self, forKey: .locations)
        notes = try container.decode([Note].self, forKey: .notes)
        mapDelta = try container.decode(Coordinates?.self, forKey: .mapDelta)
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
        try container.encode(notes, forKey: .notes)
        try container.encode(mapDelta, forKey: .mapDelta)
    }

    func delete(_ location: Location) {
        guard let index = locations.firstIndex(of: location) else { return }
        locations.remove(at: index)
    }
    
    func append(_ location: Location) {
        locations.append(location)
    }
}
