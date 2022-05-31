//
//  PhotosGridView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 26/05/22.
//

import SwiftUI

struct PhotosGridView: View {
    @EnvironmentObject private var dataController: DataController

    let hideDismissButton: Bool
    @Binding var photos: [Photo]

    @Environment(\.dismiss) var dismiss
    @Environment(\.displayScale) private var displayScale

    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 200, height: 200)

    init(photos: Binding<[Photo]>, hideDismissButton: Bool = false) {
        _photos = photos
        self.hideDismissButton = hideDismissButton
    }

    private var imageSize: CGSize {
        CGSize(
            width: Self.itemSize.width * min(displayScale, 2),
            height: Self.itemSize.height * min(displayScale, 2)
        )
    }

    private var columns: [GridItem] { [
        GridItem(.adaptive(minimum: Self.itemSize.width, maximum: Self.itemSize.height))
    ] }

    var body: some View {
        if hideDismissButton {
            content
        } else {
            NavigationView {
                content
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button(action: dismiss.callAsFunction) {
                            Image(systemName: "xmark")
                                .font(.title2.weight(.semibold))
                        }
                        .buttonStyle(.bordered)
                        .tint(.accentColor)
                        .clipShape(Circle())
                    }
            }
        }
    }

    var content: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach($photos) { $photo in
                    Image(photo: photo)
                        .resizable()
                        .frame(width: Self.itemSize.width, height: Self.itemSize.height)
                        .cornerRadius(Self.itemCornerRadius)
                }
            }
            .padding(hideDismissButton ? [] : [.top])
        }
        .background {
            if !hideDismissButton {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            }
        }
    }
}

struct PhotosGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosGridView(photos: .constant(.example))
            .environmentObject(DataController())
    }
}
