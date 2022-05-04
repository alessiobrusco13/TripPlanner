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
}
