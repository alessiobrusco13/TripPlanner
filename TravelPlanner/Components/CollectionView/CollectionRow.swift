//
//  CollectionRow.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import Foundation

protocol CollectionRow: Hashable {
    associatedtype Item: Hashable & Identifiable
    associatedtype Section: Hashable

    var section: Section { get }
    var items: [Item] { get }
}
