//
//  DocumentPicker.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        private let savePath = FileManager.documentsDirectory.appendingPathComponent("documents")
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            for url in urls {
                guard url.startAccessingSecurityScopedResource() else { return }
            }
            
            defer {
                Task { @MainActor in
                    urls.forEach { $0.stopAccessingSecurityScopedResource() }
                }
            }
            
            let documents = urls.map(Document.init)
            parent.selection.append(contentsOf: documents)
            controller.dismiss(animated: true)
        }
    }
    
    @Binding var selection: [Document]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.text, .pdf, .rtf, .rtfd, .png, .jpeg])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = true
        picker.shouldShowFileExtensions = true
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
