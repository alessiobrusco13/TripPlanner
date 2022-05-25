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
    @ViewBuilder let ellipseMenuContent: () -> Content

    @State private var editing = false

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
                            .wiggle(enabled: $editing)
                    }
                } footer: {
                    buttons
                }
            }
        }
        .animation(.default, value: location.images)
    }

    var buttons: some View {
        VStack {
            addImageButton
            ellipsisButton

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

    var ellipsisButton: some View {
        Menu(content: ellipsisButtonActions) {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
        }
        .buttonBackground()
    }

    @ViewBuilder
    func ellipsisButtonActions() -> some View {
        if !location.images.isEmpty {
            Button {
                withAnimation {
                    editing = true
                }
            } label: {
                Label("Edit Photos", systemImage: "pencil")
            }
        }

        ellipseMenuContent()
    }
}

fileprivate extension View {
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
        ImagesRowView(location: .constant(.example)) {
            EmptyView()
        }
        .ignoresSafeArea()
    }
}
