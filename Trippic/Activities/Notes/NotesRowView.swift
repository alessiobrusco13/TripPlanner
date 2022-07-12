//
//  NotesRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct NotesRowView: View {
    @Binding var notes: [Note]
    
    var body: some View {
        NavigationLink {
            NotesView(notes: $notes)
        } label: {
            HStack(spacing: 3) {
                Text("Notes")
                    .font(.body.weight(.medium))

                Image(systemName: "chevron.right")
                    .font(.body.weight(.medium))
                    .offset(y: 1)
            }
            .foregroundStyle(.selection)
        }
        .padding(1)
    }
}

struct NotesRowView_Previews: PreviewProvider {
    static var previews: some View {
        NotesRowView(notes: .constant([.example]))
    }
}
