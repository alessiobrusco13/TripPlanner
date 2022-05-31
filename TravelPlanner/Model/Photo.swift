//
//  Photo.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 28/05/22.
//

import SwiftUI

struct Photo: Identifiable, Hashable, Codable {
    enum CodingKeys: CodingKey {
        case image, isFavorite
    }

    let image: UIImage
    var isFavorite: Bool

    var id: Int {
        image.hashValue
    }

    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }

    static let example = Photo(image: [UIImage].example[0], location: .example)

    init(image: UIImage, location: Location?) {
        self.image = image
        self.isFavorite = false
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.image = try container.decode(UIImage.self, forKey: .image)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(image, forKey: .image)
        try container.encode(isFavorite, forKey: .isFavorite)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
