//
//  DocumentThumbnail.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct DocumentThumbnail: View {
    @StateObject private var generator: ThumbnailGenerator
    
    init(document: Document) {
        _generator = StateObject(wrappedValue: ThumbnailGenerator(document: document))
    }
    
    var body: some View {
        Group {
            if let image = generator.image {
                image
            } else {
                Image(systemName: "doc")
                    .task {
                        await generator.generateThumbnail()
                    }
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 10)
    }
}

struct DocumentThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        DocumentThumbnail(document: .example)
    }
}
