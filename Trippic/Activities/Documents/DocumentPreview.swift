//
//  DocumentPreview.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 12/07/22.
//

import QuickLook
import SwiftUI

struct DocumentPreview: UIViewControllerRepresentable {
    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: DocumentPreview
        
        init(_ parent: DocumentPreview) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            parent.document.url as NSURL
        }
    }
    
    let document: Document

    func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .done,
            primaryAction: UIAction { _ in
                controller.dismiss(animated: true)
            }
        )
        
        return UINavigationController(rootViewController: controller)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct DocumentPreview_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPreview(document: .example)
    }
}
