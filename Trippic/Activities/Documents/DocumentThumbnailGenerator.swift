//
//  DocumentThumbnailGenerator.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import QuickLookThumbnailing
import SwiftUI

extension DocumentThumbnail {
    class ThumbnailGenerator: ObservableObject {
        let document: Document
        
        @Environment(\.displayScale) var displayScale
        @Published var image: Image?
        
        init(document: Document) {
            self.document = document
        }
        
        func generateThumbnail() async {
            let size = CGSize(width: 68, height: 88)
            let request = QLThumbnailGenerator.Request(fileAt: document.url, size: size, scale: displayScale, representationTypes: .thumbnail)
            
            guard let representation = try? await QLThumbnailGenerator.shared.generateBestRepresentation(for: request) else {
                return
            }
            
            Task { @MainActor in
                image = Image(representation.cgImage, scale: displayScale, label: Text("Document"))
            }
        }
    }
}
