//
//  PhotosListView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 06/07/22.
//

import SwiftUI

struct PhotosListView: View {
    @Binding var photos: [PhotoAsset]
    let editingEnabled: Bool
    
    @EnvironmentObject private var dataController: DataController
    @State private var selectedPhotos = Set<PhotoAsset>()
    
    var body: some View {
        List(selection: $selectedPhotos) {
            ForEach($photos, content: PhotoRowView.init)
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Spacer()
                    
                    Button(role: .destructive) {
                        delete(selectedPhotos)
                        selectedPhotos.removeAll()
                    } label: {
                        Label("Delete selected", systemImage: "trash")
                    }
                    .disabled(selectedPhotos.isEmpty)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                if editingEnabled {
                    EditButton()
                }
            }
        }
    }
    
    func delete(_ offsets: IndexSet) {
        withAnimation {
            photos.remove(atOffsets: offsets)
        }
    }
    
    func delete(_ selected: Set<PhotoAsset>) {
        withAnimation {
            photos.removeAll(where: selected.contains)
        }
    }
}

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosListView(photos: .constant(.example), editingEnabled: true)
    }
}
