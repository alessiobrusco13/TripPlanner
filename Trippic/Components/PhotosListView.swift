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
            ForEach($photos) { $photo in
                HStack {
                    PhotoView(asset: photo) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                    }
                    
                    Spacer()
                    
                    DatePicker("Cration Date", selection: $photo.creationDate)
                        .labelsHidden()
                    
                    Spacer()
                }
                .tag(photo)
            }
            .onDelete {
                delete($0)
            }
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
