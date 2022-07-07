//
//  UIImage-example.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 18/05/22.
//

import SwiftUI

extension UIImage {
    static let example = UIImage(named: "Example1")!
}

extension Array where Element == UIImage {
    static let example = [
        UIImage(named:"Example1")!,
        UIImage(named:"Example2")!,
        UIImage(named:"Example3")!,
        UIImage(named:"Example4")!,
        UIImage(named:"Example5")!
    ]
}

extension Array where Element == PhotoAsset {
    static var example: [PhotoAsset] {
        [UIImage].example.map { PhotoAsset(image: $0) }
    }
}
