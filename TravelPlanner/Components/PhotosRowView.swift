//
//  PhotosRowView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import MapKit
import SwiftUI

struct PhotosRowView<Content: View>: View {
    @Binding var location: Location
    @ViewBuilder let ellipseMenuContent: (@escaping () -> Void) -> Content

    @State private var editing = false
    @State private var isWiggling = false
    @State private var showingDeleteConfirmation = false
    
    @State private var newImage: UIImage?

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: location.locationCoordinates,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }

    var rows: [GridItem] {
        [.init(.flexible(minimum: 200, maximum: 200))]
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, pinnedViews: .sectionFooters) {
                    Section {
                        HStack {
                            Map(coordinateRegion: .constant(region), annotationItems: [location]) {
                                MapMarker(coordinate: $0.locationCoordinates, tint: Color("AccentColor"))
                            }
                            .disabled(true)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(width: 225, height: 225)
                            .padding(.leading)

                            Divider()
                        }

                        ForEach($location.photos, id: \.self) { $photo in
                            Image(photo: photo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 225, height: 225)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(alignment: .topTrailing) {
                                    if editing {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                location.delete(photo)
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
                                        .padding(-10)
                                        .transition(.scale)
                                    } else {
                                        FavoriteButton(photo: $photo)
                                            .padding(5)
                                            .transition(.scale)
                                    }
                                }
                                .wiggle(enabled: $editing, isWiggling: $isWiggling)
                                .id(photo.id)
                        }
                    } footer: {
                        buttons(proxy: proxy)
                    }
                }
            }
        }
        .animation(.default, value: location.photos)
        .onDisappear {
            withAnimation {
                editing = false
            }
        }
        .onChange(of: newImage) { image in
            guard let image = image else { return }
            location.photos.append(Photo(image: image))
        }
    }

    func buttons(proxy: ScrollViewProxy) -> some View {
        VStack {
            addPhotoButton
            ellipsisButton(proxy: proxy)

            if editing {
                cancelButton
                    .transition(.move(edge: .trailing))
            }
        }
        .padding(8)
    }

    var addPhotoButton: some View {
        PhotoPicker(selection: $newImage) {
            Image(systemName: "photo.on.rectangle")
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
        }
        .buttonBackground()
    }

    var cancelButton: some View {
        Button {
            withAnimation {
                editing.toggle()
            }
        } label: {
            Image(systemName: "checkmark")
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
        }
        .buttonBackground(color: .green)
    }

    func ellipsisButton(proxy: ScrollViewProxy) -> some View {
        Menu {
            ellipseMenuContent {
                withAnimation {
                    editing = true
                    proxy.scrollTo(0, anchor: .center)
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
        }
        .buttonBackground()
    }
}

private extension View {
    func buttonBackground(color: Color = .accentColor) -> some View {
        self
            .background {
                color
            }
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.3), radius: 10)
    }
}

struct PhotosRowView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosRowView(location: .constant(.example)) {_ in
            EmptyView()
        }
        .ignoresSafeArea()
    }
}
