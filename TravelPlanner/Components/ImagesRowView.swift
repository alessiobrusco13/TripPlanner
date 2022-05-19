//
//  ImagesRowView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 18/05/22.
//

import SwiftUI

struct ImagesRowView: View {
    @Binding var images: [UIImage]

    var rows: [GridItem] {
        [.init(.flexible())]
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, pinnedViews: .sectionFooters) {
                Section {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 225, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                } footer: {
                    PhotoPicker(selection: $images) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                Color.accentColor
                            }
                            .clipShape(Circle())
                    }
                    .frame(maxHeight: 100)
                    .shadow(color: .black.opacity(0.3), radius: 20)
                }
                .padding(.trailing, 2)
            }
            .padding(.horizontal)
        }
    }
}

struct ImagesRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImagesRowView(images: .constant(.example))
                .frame(height: 220)

            ImagesRowView(images: .constant([]))
                .frame(height: 220)
        }
        .previewLayout(.sizeThatFits)
    }
}
