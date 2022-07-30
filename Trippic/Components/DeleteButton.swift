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
                .labelStyle(.iconOnly)
                .font(.title2)
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
    
    struct SafeAreaInsetModifier: ViewModifier {
        @Binding var data: [Item]
        @Binding var selection: Set<Item>
        var completion: (() -> Void)?
        
        @Environment(\.editMode) var editMode
        
        func body(content: Content) -> some View {
            content
                .safeAreaInset(edge: .bottom) {
                    if editMode?.wrappedValue.isEditing ?? false {
                        HStack {
                            Spacer()
                            
                            DeleteButton(data: $data, selection: $selection)
                        }
                        .padding()
                        .background(.regularMaterial)
                    }
                }
        }
    }
}

extension View {
    func deleteButton<Item: Hashable>(
        data: Binding<[Item]>,
        selection: Binding<Set<Item>>,
        completion: (() -> Void)? = nil
    ) -> some View {
        modifier(DeleteButton.SafeAreaInsetModifier(data: data, selection: selection, completion: completion))
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton<Int>(data: .constant([]), selection: .constant([]))
    }
}
