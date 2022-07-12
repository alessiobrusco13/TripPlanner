//
//  Note.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import Foundation

struct Note: Identifiable, Hashable, Codable {
    let id: UUID
    var text: String
    var lastUpdate: Date
    
    static let example: Note = {
        var note = Note()
        note.text = "Today I went to the Louvre Museum. It was amazing!"
        return note
    }()
    
    init() {
        text = ""
        id = UUID()
        lastUpdate = .now
    }
}
