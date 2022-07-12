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
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: [.init(.adaptive(minimum: 200, maximum: 200))]) {
                    ForEach($notes) { $note in
                        NoteItemView(note: $note)
                            .id(note.id)
                            .focused($focusedNoteID, equals: note.id)
                            .transition(.slide)
                            .contextMenu {
                                Button(role: .destructive) {
                                    remove(note)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
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
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.opacity)
                }
            }
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
                    Button {
                        notes.append(Note())
                    } label: {
                        Label("New Note", systemImage: "square.and.pencil")
                    }
                }
            }
            .animation(.default, value: notes)
            .onChange(of: focusedNoteID) {
                scrollTo($0, proxy: proxy)
            }
        }
    }
    
    func remove(_ note: Note) {
        guard let index = notes.firstIndex(of: note) else { return }
        notes.remove(at: index)
    }
    
    func scrollTo(_ id: UUID?, proxy: ScrollViewProxy) {
        guard let id = id else { return }
        withAnimation {
            proxy.scrollTo(id, anchor: .bottom)
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(notes: .constant([.example, Note(), Note(), Note(), Note()]))
    }
}
