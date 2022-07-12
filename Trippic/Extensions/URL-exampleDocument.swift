//
//  URL-exampleDocument.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import Foundation

extension URL {
    static var exampleDocument: URL {
        Bundle.main.url(forResource: "TestDocument", withExtension: "rtf")!
    }
}
