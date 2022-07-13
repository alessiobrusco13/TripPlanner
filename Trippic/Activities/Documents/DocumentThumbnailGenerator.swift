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
        
        @Published var error: Error? {
            didSet {
                if error != nil {
                    Task { @MainActor in
                        showingError = true
                    }
                }
            }
        }
        
        @Published var showingError = false
        
        init(document: Document) {
            self.document = document
        }
        
        func generateThumbnail() async {
            guard document.url.startAccessingSecurityScopedResource() else { return }
            defer { document.url.stopAccessingSecurityScopedResource() }
            
            let size = CGSize(width: 68, height: 88)
            let request = QLThumbnailGenerator.Request(fileAt: document.url, size: size, scale: displayScale, representationTypes: .thumbnail)
            
            do {
                let representation = try await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
                
                Task { @MainActor in
                    image = Image(representation.cgImage, scale: displayScale, label: Text("Document"))
                }
            } catch {
                Task { @MainActor in
                    guard self.error == nil else { return }
                    self.error = error
                }
            }
            
            
        }
    }
}
