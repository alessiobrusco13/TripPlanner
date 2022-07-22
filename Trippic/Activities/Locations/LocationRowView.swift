//
//  LocationRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import MapKit
import SwiftUI

struct LocationRowView: View {
    @EnvironmentObject private var dataController: DataController
    @ObservedObject var trip: Trip
    @Binding var location: Location
    
    @State private var showingDeleteConfirmation = false
    @State private var newLocation: Location?
    @State private var newIdentifier: String?
    @State private var changingLocation = false
    @Environment(\.editMode) private var editMode
    
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
                        Button(action: openInMaps) {
                            Map(coordinateRegion: .constant(region), annotationItems: [location]) {
                                MapMarker(coordinate: $0.locationCoordinates, tint: Color("AccentColor"))
                            }
                            .disabled(true)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .frame(width: 225, height: 225)
                            .padding(.leading)
                        }
                        
                        Divider()
                    }
                    
                    ForEach($location.photos) { $photo in
                        NavigationLink {
                            PhotosGridView(photos: $location.photos, startingSelection: photo)
                        } label: {
                            PhotoView(asset: photo) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 225, height: 225)
                                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    .overlay(alignment: .topTrailing) {
                                        FavoriteButton(photo: $photo)
                                            .padding(5)
                                            .transition(.scale)
                                    }
                            }
                        }
                        .buttonStyle(.outline)
                        .id(photo.id)
                    }
                } footer: {
                    buttons
                }
            }
            .padding(.vertical, 2)

        }
        .ignoresSafeArea()
        .animation(.default, value: location.photos)
        .onChange(of: newIdentifier) { identifier in
            guard let identifier =  identifier else { return }
            location.photos.append(PhotoAsset(identifier: identifier))
        }
        .confirmationDialog(
            "Are you sure you want to permanently delete this location?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    trip.delete(location)
                }
            }
        }
        .locationPicker(isPresented: $changingLocation, selection: $newLocation)
        .onChange(of: newLocation) { newValue in
            withAnimation {
                guard let newValue = newValue else { return }
                location.update(location: newValue)
            }
        }
    }
    
    var buttons: some View {
        VStack {
            addPhotoButton
            ellipsisButton
        }
        .padding(8)
    }
    
    var addPhotoButton: some View {
        PhotoPickerLink(idSelection: $newIdentifier) {
            Image(systemName: "photo.on.rectangle")
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
        }
        .buttonBackground()
    }
    
    var ellipsisButton: some View {
        Menu {
            Button(role: .destructive) {
                showingDeleteConfirmation.toggle()
            } label: {
                Label("Remove Location", systemImage: "trash")
            }
            
            Divider()

            Button {
                changingLocation.toggle()
            } label: {
                Label("Change Location", systemImage: "mappin.and.ellipse")
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
    
    func openInMaps() {
        let mapItem = MKMapItem(location: location)
        mapItem.openInMaps()
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
        LocationRowView(trip: .example, location: .constant(.example)) 
        .ignoresSafeArea()
        .environmentObject(DataController())
    }
}
