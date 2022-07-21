//
//  DeleteButton.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 20/07/22.
//

import SwiftUI

struct DeleteButton<Item: Hashable>: View {
    @Binding var data: [Item]
    @Binding var selection: Set<Item>
    var completion: (() -> Void)?
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: delete) {
            Label("Delete Selection", systemImage: "trash")
        }
        .disabled(selection.isEmpty)
    }
    
    func delete() {
        withAnimation {
            data.removeAll(where: selection.contains)
        }
        
        editMode?.wrappedValue = .inactive
        completion?()
        selection.removeAll()
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton<Int>(data: .constant([]), selection: .constant([]))
    }
}
