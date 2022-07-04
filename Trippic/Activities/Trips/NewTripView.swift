//
//  NewTripView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

struct NewTripView: View {
    @EnvironmentObject private var dataController: DataController
    @Environment(\.dismiss) var dismiss

    @StateObject private var newTrip = Trip()
    @State private var uiImage: UIImage?

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

                        PhotoPickerLink(imageSelection: $uiImage) {
                            if let image = image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                                    .foregroundColor(.clear)
                            } else {
                                PhotoPickerLink(imageSelection: $uiImage) {
                                    Label("Add Photo", systemImage: "camera.fill")
                                        .font(.headline)
                                        .foregroundStyle(.selection)
                                }
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
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dataController.add(newTrip)
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .font(.body.weight(.semibold))
                    }
                    .disabled(newTrip.name.isEmpty || (image == nil))
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss", action: dismiss.callAsFunction)
                }
            }
            .onChange(of: uiImage ?? UIImage()) { newImage in
                newTrip.image = newImage
            }
        }
    }
}

struct NewTripView_Previews: PreviewProvider {
    static var previews: some View {
        NewTripView()
            .environmentObject(DataController())
    }
}
