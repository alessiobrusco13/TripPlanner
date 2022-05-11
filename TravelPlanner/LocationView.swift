//
//  LocationView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 08/05/22.
//

import SwiftUI

struct LocationView: View {
    @Binding var location: Location
    
    var body: some View {
        VStack {
            Text(location.name)
                .font(.title.weight(.semibold))
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(location: .constant(.example))
    }
}
