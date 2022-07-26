//
//  PhotoAsset.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 28/05/22.
//

import Photos
import SwiftUI

struct PhotoAsset: Identifiable, Hashable, Codable {
    enum CodingKeys: CodingKey {
        case id, identifier, isFavorite
    }
    
    let id: UUID
    
    var identifier: String
    var isFavorite: Bool
    var creationDate = Date.now
    
    var index: Int?
    var phAsset: PHAsset?

    static func ==(lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        lhs.id == rhs.id
    }
    
    static func loadPHAsset(withIdentifier identifier: String) -> PHAsset? {
        let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        return fetchedAssets.firstObject
    }

    static let example = PhotoAsset(image: .example)

    init(image: UIImage) {
        identifier = UUID().uuidString
        id = UUID()
        self.isFavorite = false
        self.phAsset = Self.loadPHAsset(withIdentifier: identifier)
    }
    
    init(phAsset: PHAsset, index: Int?) {
        self.phAsset = phAsset
        self.index = index
        self.identifier = phAsset.localIdentifier
        self.isFavorite = false
        id = UUID()
    }
    
    init(identifier: String) {
        self.identifier = identifier
        self.phAsset = Self.loadPHAsset(withIdentifier: identifier)
        self.isFavorite = false
        id = UUID()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.id = try container.decode(UUID.self, forKey: .id)
    
        self.phAsset = Self.loadPHAsset(withIdentifier: identifier)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(id, forKey: .id)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
