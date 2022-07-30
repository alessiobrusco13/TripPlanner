//
//  PhotosView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 01/06/22.
//

import SwiftUI

struct PhotosTabView: View {
    @Binding var photos: [PhotoAsset]
    let editingEnabled: Bool
    let dismiss: () -> Void
    
    @State private var selection: PhotoAsset
    @State private var yOffset = 0.0
    
    init(photos: Binding<[PhotoAsset]>, initialSelection: PhotoAsset, editingEnabled: Bool, dismiss: @escaping () -> Void) {
        _photos = photos
        _selection = State(initialValue: initialSelection)
        self.editingEnabled = editingEnabled
        self.dismiss = dismiss
    }
    
    init(photo: PhotoAsset, dismiss: @escaping () -> Void) {
        _photos = .constant([photo])
        _selection = State(wrappedValue: photo)
        editingEnabled = false
        self.dismiss = dismiss
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 150)
            .onChanged { value in
                withAnimation {
                    yOffset = value.translation.height
                }
            }
            .onEnded { _ in
                if yOffset >= 200 {
                    dismiss()
                } else {
                    withAnimation(.spring()) {
                        yOffset = 0
                    }
                }
            }
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach($photos) { $photo in
                PhotoPageView(photo: $photo, editingEnabled: editingEnabled)
                    .tag(photo)
                    .offset(y: yOffset)
                    .gesture(dragGesture)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 15) {
                if photos.count > 1 {
                    HStack {
                        ForEach(photos.indices, id: \.self) { index in
                            Circle()
                                .fill((photos[index] == selection) ? .primary : .secondary)
                                .frame(width: 8)
                        }
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 20)
                    .background(.regularMaterial, in: Capsule())
                }
                
                buttons
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .background(.regularMaterial)
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    var buttons: some View {
        if let index = photos.firstIndex(of: selection) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                
                if editingEnabled {
                    Button {
                        withAnimation {
                            photos[index].isFavorite.toggle()
                        }
                    } label: {
                        Image(systemName: "heart")
                            .symbolVariant(photos[index].isFavorite ? .fill : .none)
                    }
                }
            }
            .font(.title)
        }
    }
}

struct PhotosTabView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosTabView(photos: .constant(.example), initialSelection: .example, editingEnabled: true) { }
            .environmentObject(DataController())
    }
}
