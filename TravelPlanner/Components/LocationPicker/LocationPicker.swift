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
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .font(.title2.weight(.semibold))
                        
                        Text(location.extendedName)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .overlay {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        
                        Text("Loading".uppercased())
                            .foregroundColor(.secondary)
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
