//
//  TripView.swift
//  TravelPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 04/05/22.
//

import SwiftUI

struct TripView: View {
    @ObservedObject var trip: Trip

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(trip: .example)
    }
}
