//
//  LocationInfoView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 11/05/22.
//

import SwiftUI

struct LocationInfoView: View {
    @Binding var location: Location
    @Binding var navigationLinkActive: Bool
    
    var body: some View {
        NavigationLink(isActive: $navigationLinkActive) {
            PhotosGridView(photos: $location.photos)
                .navigationTitle(location.name)
        } label: {
            VStack(alignment: .leading) {
                Text(location.extendedName)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(location.name)
                        .font(.title.weight(.semibold))
                    
                    if !location.photos.isEmpty {
                        Image(systemName: "chevron.right")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.gray)
                    }
                }
            }
            .lineLimit(1)
        }
        .buttonStyle(.noPressEffect)
        .disabled(location.photos.isEmpty)
        .foregroundStyle(.primary)
    }
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationInfoView(location: .constant(Location.example), navigationLinkActive: .constant(false))
    }
}
