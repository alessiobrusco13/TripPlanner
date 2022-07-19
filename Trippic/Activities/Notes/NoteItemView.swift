//
//  NoteItemView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct NoteItemView: View {
    @Binding var note: Note
    @State private var showingDocuments = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: "\(note.lastUpdate.formatted())")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
            
            PlaceholderTextEditor(text: $note.text, placeholder: "Type to edit note...")
                .onChange(of: note.text) { _ in
                    note.lastUpdate = .now
                }
            
            DisclosureGroup("Attachments") {
                DocumentsRowView(documents: $note.documents)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.quaternary)
        }
        .frame(width: 200, height: 200)
        .contentShape(Rectangle())
    }
}

struct NoteItemView_Previews: PreviewProvider {
    static var previews: some View {
        NoteItemView(note: .constant(.example))
    }
}
