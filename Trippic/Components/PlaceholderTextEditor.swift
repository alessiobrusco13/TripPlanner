//
//  PlaceholderTextEditor.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct PlaceholderTextEditor: View {
    @Binding var text: String
    let placeholder: LocalizedStringKey
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .focused($focused)
                
                if text == "" && !focused {
                    Text(placeholder)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .onTapGesture {
                            focused = true
                        }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                if focused {
                    Button("Done") {
                        focused = false
                    }
                }
            }
        }
    }
}

struct PlaceholderTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderTextEditor(text: .constant(""), placeholder: "Type here...")
    }
}
