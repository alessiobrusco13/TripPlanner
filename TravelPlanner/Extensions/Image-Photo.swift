//
//  Image-Photo.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 29/05/22.
//

import SwiftUI

extension Image {
    init(photo: Photo) {
        self.init(uiImage: photo.image)
    }
}
