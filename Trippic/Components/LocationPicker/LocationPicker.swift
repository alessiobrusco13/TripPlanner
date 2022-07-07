//
//  LocationPicker.swift
//  Trippic
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
            GeometryReader { geo in
                List {
                    if viewModel.locations.isEmpty {
                        placeholderView(size: geo.size)
                    } else {
                        ForEach(viewModel.locations) { location in
                            Button {
                                selection = location
                                dismiss()
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(location.name)
                                        .font(.title2.weight(.semibold))
                                    
                                    Text(location.extendedName)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .searchable(text: $viewModel.searchText)
            }
            .navigationTitle("Select your location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                        .foregroundStyle(.selection)
                }
            }
        }
    }
    
    func placeholderView(size: CGSize) -> some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                    
                    Text("Loading".uppercased())
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Type to find a location.")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .listRowBackground(EmptyView())
        .frame(width: size.width, height: size.height * 0.8)
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
}

struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}

extension LocationPickerView_Previews {
    struct Preview: View {
        @State private var selection: Location?
        @State private var showingPicker = false
        
        var body: some View {
            NavigationView {
                VStack {
                    if let selection = selection {
                        LocationRowView(location: .constant(selection), navigationLinkActive: .constant(false))
                    }
                    
                    Button("Pick Location") {
                        showingPicker.toggle()
                    }
                }
                .locationPicker(isPresented: $showingPicker, selection: $selection)
            }
        }
    }
}
