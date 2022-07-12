//
//  DocumentView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct DocumentView: View {
    let document: Document
    @State private var showingPreview = false
    
    var body: some View {
        Button {
            showingPreview.toggle()
        } label: {
            DocumentThumbnail(document: document)
        }
        .fullScreenCover(isPresented: $showingPreview) {
            DocumentPreview(document: document)
                .ignoresSafeArea()
        }
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(document: .example)
    }
}
