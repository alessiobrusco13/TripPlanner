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
        
        private let savePath: URL = {
            let path = FileManager.documentsDirectory.appendingPathComponent("documents")
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false)
            return path
        }()
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            do {
                var documents = [Document]()
                
                for url in urls {
                    guard url.startAccessingSecurityScopedResource() else { throw URLError(.noPermissionsToReadFile) }
                    
                    let documentURL = savePath.appendingPathComponent(url.lastPathComponent)
                    try FileManager.default.copyItem(at: url, to: documentURL)
                    documents.append(Document(url: documentURL))
                    
                    url.stopAccessingSecurityScopedResource()
                }
                
                parent.selection.append(contentsOf: documents)
                controller.dismiss(animated: true)
            } catch {
                print(error.localizedDescription)
                print(urls)
            }
        }
    }
    
    @Binding var selection: [Document]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.text, .pdf, .rtf, .rtfd, .png, .jpeg], asCopy: true)
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
