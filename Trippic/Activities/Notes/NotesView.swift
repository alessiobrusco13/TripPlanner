//
//  NotesView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct NotesView: View {
    @Binding var notes: [Note]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init(.adaptive(minimum: 200, maximum: 200))]) {
                ForEach($notes) { $note in
                    NoteItemView(note: $note)
                }
            }
            .padding(10)
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(notes: .constant([.example, Note(), Note(), Note(), Note()]))
    }
}
