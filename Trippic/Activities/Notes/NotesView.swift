//
//  NotesView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct NotesView: View {
    @Binding var notes: [Note]
    @FocusState private var focusedNoteID: UUID?
    
    @State private var editingSelection = Set<Note>()
    @Environment(\.editMode) var editMode
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: [.init(.adaptive(minimum: 150, maximum: 200))]) {
                    ForEach($notes) { $note in
                        NoteItemView(note: $note, editingSelection: $editingSelection)
                            .id(note.id)
                            .focused($focusedNoteID, equals: note.id)
                            .transition(.slide)
                            .deleteContextMenu(contentShape: Rectangle()) {
                                delete(note)
                            }
                    }
                }
                .padding(10)
            }
            .disabled(notes.isEmpty)
            .navigationTitle("Notes")
            .overlay {
                if notes.isEmpty {
                    Text("There aren't any notes for this trip.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .transition(.opacity)
                }
            }
            .deleteButton(data: $notes, selection: $editingSelection)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        
                        Button("Done") {
                            focusedNoteID = nil
                        }
                        .font(.body.weight(.semibold))
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    HStack(spacing: 20) {
                        Button(action: appendNote) {
                            Label("New Note", systemImage: "square.and.pencil")
                        }
                        
                        if !notes.isEmpty {
                            EditButton()
                                .frame(width: 55)
                        }
                    }
                }
            }
            .animation(.default, value: notes)
            .onChange(of: focusedNoteID) {
                scrollTo($0, proxy: proxy)
            }
            .onChange(of: editMode?.wrappedValue) { _ in
                focusedNoteID = nil
                
                guard editingSelection.isEmpty == false else { return }
                editingSelection.removeAll()
            }
        }
    }
    
    func delete(_ note: Note) {
        guard let index = notes.firstIndex(of: note) else { return }
        notes.remove(at: index)
    }
    
    func scrollTo(_ id: UUID?, proxy: ScrollViewProxy) {
        guard let id = id else { return }
        withAnimation {
            proxy.scrollTo(id, anchor: .bottom)
        }
    }
    
    func appendNote() {
        let note = Note()
        editMode?.wrappedValue = .inactive
        
        withAnimation {
            notes.append(note)
            focusedNoteID = note.id
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(notes: .constant([.example, Note(), Note(), Note(), Note()]))
    }
}
