//
//  OutlineButtonStyle.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 20/07/22.
//

import SwiftUI

struct OutlineButtonStyle: ButtonStyle {
    let editModeUIEnabled: Bool
    
    let isItemSelected: Bool
    @Environment(\.editMode) var editMode
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                if configuration.isPressed || isItemSelected {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.selection, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                }
            }
            .overlay(alignment: .bottom) {
                if editMode?.wrappedValue.isEditing ?? false {
                    Image(systemName: isItemSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 5)
                }
            }
            .contentShape(Rectangle())
    }
}

extension ButtonStyle where Self == OutlineButtonStyle {
    static func outline(selected: Bool, editUIEnabled: Bool = true) -> OutlineButtonStyle {
        OutlineButtonStyle(editModeUIEnabled: editUIEnabled, isItemSelected: selected)
    }
    
    static var outline: OutlineButtonStyle {
        OutlineButtonStyle(editModeUIEnabled: false, isItemSelected: false)
    }
}

struct GridItemButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            print("Pressed")
        } label: {
            Label("Press Me", systemImage: "star")
        }
        .buttonStyle(.outline(selected: true))
    }
}
