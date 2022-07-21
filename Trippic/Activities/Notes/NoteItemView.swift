//
//  NoteItemView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct NoteItemView: View {
    @Binding var note: Note
    @Binding var editingSelection: Set<Note>
    
    @Environment(\.editMode) private var editMode
    
    var selected: Bool {
        editingSelection.contains(note)
    }
    
    var body: some View {
        Button {
            if editMode?.wrappedValue.isEditing ?? false {
                toggleSelection()
            }
        } label: {
            VStack(alignment: .leading) {
                Text(verbatim: "\(note.lastUpdate.formatted())")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                
                PlaceholderTextEditor(text: $note.text, placeholder: "Type to edit note...")
                    .disabled(editMode?.wrappedValue.isEditing ?? false)
                    .onChange(of: note.text) { _ in
                        note.lastUpdate = .now
                    }
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.quaternary)
            }
            .frame(width: 200, height: 200)
        }
        .buttonStyle(.outline(selected: selected))
    }
    
    func toggleSelection() {
        if selected {
            editingSelection.remove(note)
        } else {
            editingSelection.insert(note)
        }
    }
}

struct NoteItemView_Previews: PreviewProvider {
    static var previews: some View {
        NoteItemView(note: .constant(.example), editingSelection: .constant([]))
    }
}
