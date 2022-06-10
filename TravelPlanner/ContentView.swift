//
//  ContentView.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

struct ContentView: View {
    enum Tab: Hashable {
        case trips, favorites
    }
    
    var body: some View {
        TripsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
