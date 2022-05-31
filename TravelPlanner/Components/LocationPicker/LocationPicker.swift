//
//  LocationPicker.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 11/05/22.
//

import SwiftUI

struct LocationPicker: View {
    private enum OutputMethod {
        case array, atomic
    }

    private let outputMethod: OutputMethod
    let onSelected: (inout Location) -> Void

    @Binding var atomicSelection: Location?
    @Binding var arraySelection: [Location]

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.locations) { location in
                Button {
                    if outputMethod == .atomic {
                        atomicSelection = location
                    } else {
                        arraySelection.append(location)
                    }

                    dismiss()
                } label: {
                    LocationRowView(location: location)
                }
            }
            .searchable(text: $viewModel.searchText)
            .animation(.default, value: viewModel.locations)
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
        }
    }

    init(selection: Binding<Location?>, onSelected: @escaping (inout Location) -> Void) {
        _arraySelection = .constant([])
        _atomicSelection = selection

        outputMethod = .atomic
        self.onSelected = onSelected
    }

    init(selection: Binding<[Location]>, onSelected: @escaping (inout Location) -> Void) {
        _arraySelection = selection
        _atomicSelection = .constant(nil)

        outputMethod = .array
        self.onSelected = onSelected
    }
}

extension View {
    func locationPicker(
        isPresented: Binding<Bool>,
        selection: Binding<Location?>,
        onSelected: @escaping (inout Location) -> Void = { _ in }
    ) -> some View {
        sheet(isPresented: isPresented) {
            LocationPicker(selection: selection, onSelected: onSelected)
                .foregroundStyle(.primary)
        }
    }

    func locationPicker(
        isPresented: Binding<Bool>,
        selection: Binding<[Location]>,
        onSelected: @escaping (inout Location) -> Void = { _ in }
    ) -> some View {
        sheet(isPresented: isPresented) {
            LocationPicker(selection: selection, onSelected: onSelected)
                .foregroundStyle(.primary)
        }
    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationPicker(selection: .constant(nil)) { _ in }
    }
}
