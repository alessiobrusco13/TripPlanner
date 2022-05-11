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

    @Binding var atomicSelection: Location?
    @Binding var arraySelection: [Location]

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            VStack {
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
                .navigationTitle("Select your location")
            }
        }
    }

    init(selection: Binding<Location?>) {
        _arraySelection = .constant([])
        _atomicSelection = selection

        outputMethod = .atomic
    }

    init(selection: Binding<[Location]>) {
        _arraySelection = selection
        _atomicSelection = .constant(nil)

        outputMethod = .array
    }
}

extension View {
    func locationPicker(
        isPresented: Binding<Bool>,
        selection: Binding<Location?>
    ) -> some View {
        sheet(isPresented: isPresented) {
            LocationPicker(selection: selection)
                .foregroundStyle(.primary)
        }
    }

    func locationPicker(
        isPresented: Binding<Bool>,
        selection: Binding<[Location]>
    ) -> some View {
        sheet(isPresented: isPresented) {
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
