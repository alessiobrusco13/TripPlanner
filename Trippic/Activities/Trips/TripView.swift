//
//  TripView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 04/05/22.
//

import MapKit
import SwiftUI

struct TripView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var dataController: DataController
    
    @State private var showingLocationPicker = false
    @StateObject private var viewModel: ViewModel
    
    @FocusState private var editingName: Bool
    @State private var editingTrip = false
    @State private var newID: String?
    
    @State private var showingPhotosGrid = false
    @State private var showingTripPhoto = false
    @State private var showingFullscreenMap = false
    
    @Namespace private var namespace
    
    init(trip: Trip) {
        _viewModel = StateObject(wrappedValue: ViewModel(trip: trip))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button {
                    withAnimation {
                        showingFullscreenMap.toggle()
                        viewModel.scaleUpRegion()
                    }
                } label: {
                    Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.trip.locations) { location in
                        MapMarker(coordinate: location.locationCoordinates, tint: Color("AccentColor"))
                    }
                    .matchedGeometryEffect(id: "map", in: namespace)
                    .disabled(true)
                    .frame(height: 300)
                    .cornerRadius(15)
                    .padding([.horizontal, .top])
                }
                
                VStack(spacing: 8) {
                    Button {
                        if !editingTrip {
                            withAnimation(.spring()) {
                                showingTripPhoto.toggle()
                            }
                        }
                    } label: {
                        PhotoView(asset: viewModel.trip.photo, content: CircleImage.init)
                            .frame(width: 150, height: 150)
                            .padding(.top, -130)
                            .accessibilityAddTraits(.isButton)
                            .overlay {
                                if editingTrip {
                                    PhotoPickerLink(idSelection: $newID) {
                                        Image(systemName: "photo.fill.on.rectangle.fill")
                                            .font(.largeTitle)
                                            .contentShape(Rectangle())
                                    }
                                    .padding()
                                    .background()
                                    .cornerRadius(10)
                                    .transition(.scale)
                                    .padding(.top, -70)
                                }
                            }
                    }
                    .buttonStyle(.noPressEffect)
                    
                    VStack {
                        if !editingTrip {
                            Text(viewModel.trip.name)
                                .font(.largeTitle.weight(.semibold))
                        } else {
                            HStack {
                                TextField("Enter trip name", text: $viewModel.trip.name)
                                    .focused($editingName)
                                    .font(.largeTitle.weight(.semibold))
                                    .multilineTextAlignment(.center)
                                    .onSubmit {
                                        editingName = false
                                    }
                                    .textFieldStyle(.roundedBorder)
                                    .overlay(alignment: .trailing) {
                                        Button("Done") {
                                            withAnimation {
                                                editingTrip = false
                                            }
                                        }
                                        .font(.title3.weight(.bold))
                                        .padding()
                                    }
                            }
                            .frame(maxWidth: 364)
                        }
                        
                        HStack(spacing: 5) {
                            if !editingTrip {
                                Text(viewModel.trip.startDate, format: .dateTime.day().month())
                            } else {
                                DatePicker(
                                    "Start date",
                                    selection: $viewModel.trip.startDate,
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                            }
                            
                            Image(systemName: "arrow.right")
                                .font(.caption.weight(.heavy))
                            
                            if !editingTrip {
                                Text(viewModel.trip.endDate, format: .dateTime.day().month())
                            } else {
                                DatePicker(
                                    "End date",
                                    selection: $viewModel.trip.endDate,
                                    in: viewModel.trip.startDate...,
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                            }
                        }
                        .padding(editingTrip ? 8 : 0)
                    }
                }
                
                ForEach($viewModel.trip.locations) {
                    LocationView(location: $0, trip: viewModel.trip)
                }
                
                Color.clear
                    .frame(height: 100)
                
                Spacer()
            }
        }
        .locationPicker(isPresented: $showingLocationPicker, selection: $viewModel.newLocation)
        .accessibilityHidden(showingTripPhoto || showingFullscreenMap)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(showingFullscreenMap)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(role: .destructive) {
                        dataController.delete(viewModel.trip)
                        dismiss()
                    } label: {
                        Label("Remove Trip", systemImage: "trash")
                    }
                    
                    Divider()
                    
                    Button {
                        withAnimation {
                            editingTrip = true
                            editingName = true
                        }
                    } label: {
                        Label("Edit Trip", systemImage: "pencil")
                    }
                    
                    if !viewModel.trip.locations.isEmpty {
                        Button {
                            showingPhotosGrid.toggle()
                        } label: {
                            Label("Show All Photos", systemImage: "square.grid.2x2")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.headline)
                        .padding(14)
                        .background {
                            Circle()
                                .opacity(0.2)
                        }
                }
                .disabled(showingTripPhoto || editingTrip)
            }
            
            ToolbarItem(placement: .primaryAction) {
                CircleButton(systemImage: "doc.badge.plus") {
                    showingLocationPicker.toggle()
                }
                .disabled(showingTripPhoto || editingTrip)
            }
        }
        .background {
            NavigationLink(isActive: $showingPhotosGrid) {
                PhotosView(photos: viewModel.trip.allPhotos)
                    .navigationTitle(viewModel.trip.name)
            } label: {
                EmptyView()
            }
        }
        .overlay {
            if showingTripPhoto {
                PhotosTabView(photo: viewModel.trip.photo) {
                    withAnimation {
                        showingTripPhoto = false
                    }
                }
                .transition(.move(edge: .bottom))
                .background(.ultraThinMaterial)
            }
            
            if showingFullscreenMap {
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.trip.locations) { location in
                    MapMarker(coordinate: location.locationCoordinates, tint: Color("AccentColor"))
                }
                .ignoresSafeArea()
                .matchedGeometryEffect(id: "map", in: namespace)
                .overlay(alignment: .topTrailing) {
                    Button {
                        withAnimation {
                            showingFullscreenMap.toggle()
                            viewModel.setRegion()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.secondary)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onChange(of: newID) { id in
            guard let id = id else { return }
            
            withAnimation {
                viewModel.trip.photo = PhotoAsset(identifier: id)
            }
        }
        .onChange(of: viewModel.newLocation) { location in
            guard let location =  location else { return }
            
            withAnimation {
                viewModel.trip.append(location)
                viewModel.setRegion()
            }
        }
        .onAppear {
            dataController.startCaching(viewModel.trip.allPhotos, targetSize: CGSize(width: 550, height: 550))
            viewModel.setRegion()
        }
        .onDisappear {
            dataController.stopCaching()
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripView(trip: .example)
                .environmentObject(DataController())
        }
    }
}
