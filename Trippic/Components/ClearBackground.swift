//
//  ClearBackground.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 30/07/22.
//

import SwiftUI

struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        Task { @MainActor in
            view.superview?.superview?.backgroundColor = .clear
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
