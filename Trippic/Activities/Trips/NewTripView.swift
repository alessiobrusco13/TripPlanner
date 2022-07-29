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

    @State private var tripName = ""
    @State private var startDate = Date.now
    @State private var endDate = Date.now.addingTimeInterval(1*60*60*24)
    @State private var assetID: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()

                        PhotoPickerLink(idSelection: $assetID) {
                            if let id = assetID {
                                PhotoView(asset: PhotoAsset(identifier: id)) { image in
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

                        TextField("Trip Name", text: $tripName)
                    }
                }

                Section("Dates") {
                    DatePicker(
                        "Start date:",
                        selection: $startDate,
                        displayedComponents: .date
                    )
                    .font(.headline)

                    DatePicker(
                        "End date:",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: .date
                    )
                    .font(.headline)
                }
            }
            .navigationTitle(tripName.isEmpty ? LocalizedStringKey("New Trip") : LocalizedStringKey(tripName))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        guard let assetID = assetID else { return }
                        let trip = Trip(name: tripName, startDate: startDate, endDate: endDate, assetID: assetID)
                        
                        dataController.add(trip)
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .font(.body.weight(.semibold))
                            .contentShape(Circle())
                    }
                    .disabled(tripName.isEmpty || assetID == nil)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") {
                        dismiss()
                    }
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
