//
//  Photo.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 28/05/22.
//

import SwiftUI

struct Photo: Identifiable, Hashable, Codable, Sendable {
    enum CodingKeys: CodingKey {
        case id, image, isFavorite
    }

    let id: UUID
    let image: UIImage
    var isFavorite: Bool

    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }

    static let example = Photo(image: [UIImage].example[0])

    init(image: UIImage) {
        id = UUID()
        self.image = image
        self.isFavorite = false
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.image = try container.decode(UIImage.self, forKey: .image)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(image, forKey: .image)
        try container.encode(isFavorite, forKey: .isFavorite)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
