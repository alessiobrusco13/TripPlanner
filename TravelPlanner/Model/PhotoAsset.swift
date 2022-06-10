//
//  PhotoAsset.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 28/05/22.
//

@preconcurrency import Photos
import SwiftUI

struct PhotoAsset: Identifiable, Hashable, Codable, Sendable {
    enum CodingKeys: CodingKey {
        case identifier, isFavorite
    }
    
    var id: String { identifier }
    
    var identifier: String
    var isFavorite: Bool
    
    var index: Int?
    var phAsset: PHAsset?

    static func ==(lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        lhs.id == rhs.id
    }

    static let example = PhotoAsset(image: [UIImage].example[0])

    init(image: UIImage) {
        identifier = UUID().uuidString
        self.isFavorite = false
    }
    
    init(phAsset: PHAsset, index: Int?) {
        self.phAsset = phAsset
        self.index = index
        self.identifier = phAsset.localIdentifier
        self.isFavorite = false
    }
    
    init(identifier: String) {
        self.identifier = identifier
        let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        self.phAsset = fetchedAssets.firstObject
        self.isFavorite = false
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(isFavorite, forKey: .isFavorite)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension PHObject: Identifiable {
    public var id: String { localIdentifier }
}
