//
//  Document.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import Foundation

struct Document: Identifiable, Hashable, Codable {
    let id: UUID
    var url: URL
    
    static let example = Document(url: .exampleDocument)
    
    init(url: URL) {
        self.url = url
        id = UUID()
    }
    
    init(id: UUID, url: URL) {
        self.id = UUID()
        self.url = url
    }
}
