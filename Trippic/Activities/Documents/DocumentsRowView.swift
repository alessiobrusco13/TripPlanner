//
//  DocumentsRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct DocumentsRowView: View {
    @Binding var documents: [Document]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())], pinnedViews: .sectionFooters) {
                Section {
                    ForEach(documents) { document in
                        DocumentView(document: document)
                    }
                } footer: {
                    DocumentPickerLink(selection: $documents) {
                        Image(systemName: "doc.badge.plus")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(width: 55, height: 55)
                            .background {
                                Color.accentColor
                            }
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 10)
                            .padding()
                    }
                    .padding(.leading)
                }
            }
            .padding()
        }
        .onAppear {
            print("FUCK")
            print(_documents.wrappedValue.map(\.url.absoluteString).formatted(.list(type: .and)))
        }
    }
}

struct DocumentsRowView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsRowView(documents: .constant([.example]))
    }
}
