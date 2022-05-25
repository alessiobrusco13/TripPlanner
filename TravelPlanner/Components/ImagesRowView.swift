//
//  ImagesRowView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import MapKit
import SwiftUI

struct ImagesRowView<Content: View>: View {
    @Binding var location: Location
    @ViewBuilder let ellipseMenuContent: (@escaping () -> Void) -> Content

    @State private var editing = false
    @State private var isWiggling = false
    @State private var showingDeleteConfirmation = false

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

                        ForEach(location.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 225, height: 225)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .id(location.images.firstIndex(of: image) ?? 0)
                                .overlay(alignment: .topTrailing) {
                                    if editing {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                guard let index = location.images.firstIndex(of: image) else {
                                                    return
                                                }

                                                location.images.remove(at: index)
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
                                    }
                                }
                                .wiggle(enabled: $editing, isWiggling: $isWiggling)
                        }
                    } footer: {
                        buttons(proxy: proxy)
                    }
                }
            }
        }
        .animation(.default, value: location.images)
        .onDisappear {
            withAnimation {
                editing = false
            }
        }
    }

    func buttons(proxy: ScrollViewProxy) -> some View {
        VStack {
            addImageButton
            ellipsisButton(proxy: proxy)

            if editing {
                cancelButton
                    .transition(.move(edge: .trailing))
            }
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

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesRowView(location: .constant(.example)) {_ in
            EmptyView()
        }
        .ignoresSafeArea()
    }
}
