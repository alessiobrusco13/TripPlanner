//
//  UIImage-Identifiable.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import SwiftUI

extension UIImage: Identifiable {
    public var id: UUID { UUID() }
}
