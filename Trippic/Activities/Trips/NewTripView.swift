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

//    @StateObject var newTrip = Trip()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()

                        PhotoPickerLink(assetSelection: .constant(.example)) {
                            if false {
                                PhotoView(asset: .example) { image in
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

                        TextField("Trip Name", text: .constant(""))
                    }
                }

                Section("Dates") {
                    DatePicker(
                        "Start date:",
                        selection: .constant(.now),
                        displayedComponents: .date
                    )
                    .font(.headline)

                    DatePicker(
                        "End date:",
                        selection: .constant(.now),
//                        in: .,
                        displayedComponents: .date
                    )
                    .font(.headline)
                }
            }
            .navigationTitle("newTrip.name.isEmpty ? LocalizedStringKey(\"New Trip\") : LocalizedStringKey(newTrip.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
//                        dataController.add(newTrip)
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .font(.body.weight(.semibold))
                            .contentShape(Circle())
                    }
//                    .disabled(newTrip.name.isEmpty || (newTrip.photo == .example))
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
