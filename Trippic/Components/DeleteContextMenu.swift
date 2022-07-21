//
//  DeleteContextMenu.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 21/07/22.
//

import SwiftUI

struct DeleteContextMenu<S: Shape>: ViewModifier {
    let contentShape: S
    let deleteAction: () -> Void
    
    @Environment(\.editMode) var editMode
    
    func body(content: Content) -> some View {
        content
            .contentShape(contentShape)
            .contextMenu {
                if !(editMode?.wrappedValue.isEditing ?? false) {
                    Button(role: .destructive) {
                        withAnimation {
                            deleteAction()
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
    }
}

extension View {
    func deleteContextMenu<S: Shape>(contentShape: S, deleteAction: @escaping () -> Void) -> some View {
       modifier(DeleteContextMenu(contentShape: contentShape, deleteAction: deleteAction))
    }
}

struct DeleteContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
            .modifier(DeleteContextMenu(contentShape: Rectangle()) { } )
    }
}
