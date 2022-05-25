//
//  ImagesRowView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import MapKit
import SwiftUI

struct ImagesRowView<Content: View>: View {
    struct RowData: CollectionRow {
        let section = 0
        var items: [UIImage]
    }

    @Binding var location: Location
    @ViewBuilder let ellipseMenuContent: () -> Content

    @State private var editing = false
    @State private var collectionView: UICollectionView?

    var data: [RowData] {
        var images = [UIImage.remove]
        images.insert(contentsOf: location.images, at: 1)
        return [RowData(items: images)]
    }

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: location.locationCoordinates,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }

    var lastIndex: Int {
        data.first?.items.firstIndex(of: .add) ?? 0
    }

    var body: some View {
        CollectionView(rows: data, sectionLayoutProvider: sectionProvider) { indexPath, collectionView, data in
            if indexPath.item == 0 {
                HStack {
                    Map(coordinateRegion: .constant(region), annotationItems: [location]) {
                        MapMarker(coordinate: $0.locationCoordinates, tint: Color("AccentColor"))
                    }
                    .disabled(true)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    Divider()
                }
                .background { Color(.systemGroupedBackground) }
                .onAppear {
                    self.collectionView = collectionView
                }
            } else {
                Image(uiImage: data)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 225, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .background { Color(.systemGroupedBackground) }
                    .overlay(alignment: .topTrailing) {
                        if editing {
                            Button(role: .destructive) {
                                withAnimation {
                                    _ = location.images.remove(at: indexPath.item - 1)
                                    collectionView.reloadData()
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .background {
                                Circle()
                                    .fill(.red)
                            }
                            .padding(5)
                            .transition(.scale)
                        }
                    }
            }
        }
        .animation(.default, value: location.images)
        .overlay(alignment: .trailing) {
            if location.images.isEmpty {
                buttons
                    .padding(.trailing, 50)
            } else {
                buttons
            }
        }
    }

    func sectionProvider(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(225), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -50, bottom: 0, trailing: 0)
        section.interGroupSpacing = 10
        return section
    }

    var buttons: some View {
        VStack {
            addImageButton
            ellipsisButton
        }
        .padding(8)
    }

    var addImageButton: some View {
        PhotoPicker(selection: $location.images) {
            Image(systemName: "photo.on.rectangle")
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
        }
        .background {
            Color.accentColor
        }
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.3), radius: 20)
    }

    var ellipsisButton: some View {
        Menu(content: ellipsisButtonActions) {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
        }
        .background {
            Color.accentColor
        }
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.3), radius: 20)
    }

    @ViewBuilder
    func ellipsisButtonActions() -> some View {
        Button {
            withAnimation {
                editing = true
                collectionView?.reloadData()
            }
        } label: {
            Label("Edit Photos", systemImage: "pencil")
        }

        ellipseMenuContent()
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesRowView(location: .constant(.example)) {
            EmptyView()
        }
        .ignoresSafeArea()
    }
}
