//
//  KeyedEncodingContainer-UIImage.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

enum ImageEncodingQuality {
    case png
    case jpeg(quality: CGFloat)
}

extension KeyedEncodingContainer {
    mutating func encode(
        _ value: UIImage,
        forKey key: KeyedEncodingContainer.Key,
        quality: ImageEncodingQuality = .png
    ) throws {
        let imageData: Data?
        switch quality {
        case .png:
            imageData = value.pngData()
        case .jpeg(let quality):
            imageData = value.jpegData(compressionQuality: quality)
        }
        guard let data = imageData else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: [key], debugDescription: "Failed convert UIImage to data")
            )
        }
        try encode(data, forKey: key)
    }

    mutating func encode(
        _ value: [UIImage],
        forKey key: KeyedEncodingContainer.Key,
        quality: ImageEncodingQuality = .png
    ) throws {
        var imagesData = [Data?]()

        for value in value {
            switch quality {
            case .png:
                imagesData.append(value.pngData())
            case .jpeg(let quality):
                imagesData.append(value.jpegData(compressionQuality: quality))
            }
        }

        guard (imagesData.allSatisfy { $0 != nil }) else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: [key], debugDescription: "Failed convert UIImage to data")
            )
        }

        try encode(imagesData.compactMap { $0 }, forKey: key)
    }

    mutating func encode(
        _ value: Set<UIImage>,
        forKey key: KeyedEncodingContainer.Key,
        quality: ImageEncodingQuality = .png
    ) throws {
        var imagesData = Set<Data?>()

        for value in value {
            switch quality {
            case .png:
                imagesData.insert(value.pngData())
            case .jpeg(let quality):
                imagesData.insert(value.jpegData(compressionQuality: quality))
            }
        }

        guard (imagesData.allSatisfy { $0 != nil }) else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(codingPath: [key], debugDescription: "Failed convert UIImage to data")
            )
        }

        try encode(imagesData.compactMap { $0 }, forKey: key)
    }
}

extension KeyedDecodingContainer {
    func decode(
        _ type: UIImage.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> UIImage {
        let imageData = try decode(Data.self, forKey: key)
        if let image = UIImage(data: imageData) {
            return image
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [key], debugDescription: "Failed load UIImage from decoded data")
            )
        }
    }

    func decode(
        _ type: [UIImage].Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> [UIImage] {
        let imagesData = try decode([Data].self, forKey: key)
        var images = [UIImage?]()

        for imageData in imagesData {
            images.append(UIImage(data: imageData))
        }

        guard (images.allSatisfy { $0 != nil }) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [key], debugDescription: "Failed load UIImage from decoded data")
            )
        }

        return images.compactMap { $0 }
    }

    func decode(
        _ type: Set<UIImage>.Type,
        forKey key: KeyedDecodingContainer.Key
    ) throws -> Set<UIImage> {
        let imagesData = try decode(Set<Data>.self, forKey: key)
        var images = Set<UIImage?>()

        for imageData in imagesData {
            images.insert(UIImage(data: imageData))
        }

        guard (images.allSatisfy { $0 != nil }) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [key], debugDescription: "Failed load UIImage from decoded data")
            )
        }

        return Set(images.compactMap { $0 })
    }
}
