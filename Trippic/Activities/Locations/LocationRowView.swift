//
//  LocationRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 22/05/22.
//

import SwiftUI

struct LocationRowView: View {
    @Binding var location: Location
    @Binding var allLocations: [Location]
    let onUpdate: () -> Void
    
    @State private var showingDeleteConfirmation = false
    @State private var newLocation: Location?
    @State private var newIdentifier: String?
    @State private var changingLocation = false
    
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var dataController: DataController
    
    var rows: [GridItem] {
        [.init(.flexible(minimum: 200, maximum: 200))]
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, pinnedViews: .sectionFooters) {
                Section {
                    LocationMapView(location: $location)
                    PhotosRowView(photos: $location.photos)
                } footer: {
                    buttons
                }
            }
            .padding(.vertical, 2)
        }
        .ignoresSafeArea()
        .onChange(of: newIdentifier) { identifier in
            guard let identifier =  identifier else { return }
            
            withAnimation {
                location.photos.append(PhotoAsset(identifier: identifier))
            }
        }
        .confirmationDialog(
            "Are you sure you want to permanently delete this location?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                delete(location)
            }
        }
        .locationPicker(isPresented: $changingLocation, selection: $newLocation)
        .onChange(of: newLocation) { newValue in
            withAnimation {
                guard let newValue = newValue else { return }
                location.update(location: newValue)
                onUpdate()
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
    
    func delete(_ location: Location) {
        guard let index = allLocations.firstIndex(of: location) else { return }
        
        withAnimation {
           _ = allLocations.remove(at: index)
            onUpdate()
        }
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

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(location: .constant(.example), allLocations: .constant([.example])) {
            
        }
        .ignoresSafeArea()
        .environmentObject(DataController())
    }
}
