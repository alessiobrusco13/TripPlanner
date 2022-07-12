//
//  DocumentPickerLink.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct DocumentPickerLink<Content: View>: View {
    @Binding var selection: [Document]
    @ViewBuilder let label: () -> Content
    
    @State private var showingPicker = false
    
    var body: some View {
        Button {
            showingPicker.toggle()
        } label: {
            label()
        }
        .sheet(isPresented: $showingPicker) {
            DocumentPicker(selection: $selection)
        }
    }
}

struct DocumentPickerLink_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPickerLink(selection: .constant([])) {
            
        }
    }
}
