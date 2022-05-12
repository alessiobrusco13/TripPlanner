//
//  NewTripView.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

struct NewTripView: View {
    @EnvironmentObject private var dataController: DataController
    @Environment(\.dismiss) var dismiss

    @StateObject private var newTrip = Trip()

    @State private var uiImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false

    var image: Image? {
        if let uiImage = uiImage {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()

                        if let image = image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .foregroundColor(.clear)
                                .contextMenu(menuItems: imageButtons)
                        } else {
                            Menu(content: imageButtons) {
                                Label("Add Photo", systemImage: "camera.fill")
                                    .font(.headline)
                                    .foregroundStyle(.selection)
                            }
                        }


                        Spacer()
                    }
                    .listRowBackground(EmptyView())
                }

                Section {
                    HStack {
                        Text("Name:")
                            .font(.headline)

                        TextField("Trip Name", text: $newTrip.name)
                    }
                }

                Section("Dates") {
                        DatePicker(
                            "Start date:",
                            selection: $newTrip.startDate,
                            displayedComponents: .date
                        )
                        .font(.headline)

                        DatePicker(
                            "End date:",
                            selection: $newTrip.endDate,
                            in: newTrip.startDate...,
                            displayedComponents: .date
                        )
                        .font(.headline)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(newTrip.name.isEmpty ? "New Trip" : newTrip.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dataController.add(newTrip)
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .font(.body.weight(.semibold))
                    }
                    .disabled(newTrip.name.isEmpty)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss", action: dismiss.callAsFunction)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $uiImage)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showingCamera) {
                Camera(image: $uiImage)
                    .ignoresSafeArea()
            }
            .onChange(of: uiImage ?? UIImage()) { newImage in
                newTrip.image = newImage
            }
        }
    }

    @ViewBuilder
    func imageButtons() -> some View {
        Button {
            showingImagePicker.toggle()
        } label: {
            Label("Photo Library", systemImage: "photo.on.rectangle")
        }

        Button {
            showingCamera.toggle()
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }
}

struct NewTripView_Previews: PreviewProvider {
    static var previews: some View {
        NewTripView()
            .environmentObject(DataController())
    }
}
