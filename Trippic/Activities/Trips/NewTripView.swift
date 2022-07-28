//
//  NewTripView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

struct NewTripView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss

    @StateObject private var newTrip = Trip()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        
                        PhotoPickerLink(assetSelection: $newTrip.photo) {
                            if newTrip.photo != .example {
                                PhotoView(asset: $newTrip.photo) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                        .foregroundColor(.clear)
                                }
                            } else {
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
            .navigationTitle(newTrip.name.isEmpty ? String(localized: "New Trip", defaultValue: "") : newTrip.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dataController.add(newTrip)
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .font(.body.weight(.semibold))
                            .contentShape(Circle())
                    }
                    .disabled(newTrip.name.isEmpty || (newTrip.photo == .example))
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss", action: dismiss.callAsFunction)
                        .contentShape(Rectangle())
                }
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
