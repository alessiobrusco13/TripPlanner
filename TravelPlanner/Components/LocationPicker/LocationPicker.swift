//
//  LocationPicker.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 11/05/22.
//

import SwiftUI

struct LocationPicker: View {
    @Binding var selection: Location?

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List($viewModel.locations) { $location in
                Button {
                    selection = location

                    dismiss()
                } label: {
                    LocationRowView(location: $location)
                }
            }
            .searchable(text: $viewModel.searchText)
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color(.systemGroupedBackground)
                            .ignoresSafeArea()
                        
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Select your location")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: dismiss.callAsFunction)
                        .foregroundStyle(.selection)
                }
            }
        }
    }
}

extension View {
    func locationPicker(
        isPresented: Binding<Bool>,
        selection: Binding<Location?>
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            LocationPicker(selection: selection)
                .foregroundStyle(.primary)
        }
    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPicker(selection: .constant(nil))
    }
}
