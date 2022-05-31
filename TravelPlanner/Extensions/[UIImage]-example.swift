//
//  [UIImage]-example.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 18/05/22.
//

import SwiftUI

extension Array where Element == UIImage {
    static let example = [
        UIImage(named:"Example1")!,
        UIImage(named:"Example2")!,
        UIImage(named:"Example3")!,
        UIImage(named:"Example4")!,
        UIImage(named:"Example5")!
    ]
}

extension Array where Element == Photo {
    static var example: [Photo] {
        [UIImage].example.map { image in
            Photo(image: image, location: Location.example)
        }
    }
}
