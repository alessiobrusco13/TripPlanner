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
        TabView {
            TripsView()
                .tag(Tab.trips)
                .tabItem {
                    Label("Trips", systemImage: "airplane.departure")
                }
            
            FavoritesView()
                .tag(Tab.favorites)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
