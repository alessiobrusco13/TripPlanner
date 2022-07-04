//
//  PhotosView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 01/06/22.
//

import SwiftUI

struct PhotosTabView: View {
    @Binding var photos: [PhotoAsset]
    let dismiss: () -> Void

    @State private var selection: PhotoAsset

    init(photos: Binding<[PhotoAsset]>, initialSelection: PhotoAsset, dismiss: @escaping () -> Void) {
        _photos = photos
        _selection = State(initialValue: initialSelection)
        self.dismiss = dismiss
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach($photos) { $photo in
                PhotoPageView(photo: $photo)
                    .tag(photo)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding(.bottom, 32)
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 15) {
                HStack {
                    ForEach(photos.indices, id: \.self) { index in
                        Circle()
                            .fill((photos[index] == selection) ? .primary : .secondary)
                            .frame(width: 8)
                    }
                }
                
                buttons
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .background(.regularMaterial)
            }
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
                
                Button {
                    withAnimation {
                        photos[index].isFavorite.toggle()
                    }
                } label: {
                    Image(systemName: "heart")
                        .symbolVariant(photos[index].isFavorite ? .fill : .none)
                }
            }
            .font(.title)
        }
    }
}

struct PhotosTabView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosTabView(photos: .constant(.example), initialSelection: .example) {

        }
    }
}
