//
//  TripRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

struct TripRowView: View {
    @ObservedObject var trip: Trip

    var body: some View {
        NavigationLink {
            TripView(trip: trip)
        } label: {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 5) {
                            Text(trip.startDate, format: Trip.dateFormat(trip.startDate))
                            
                            Image(systemName: "arrow.right")
                                .font(.caption.weight(.heavy))
                            
                            Text(trip.endDate, format: Trip.dateFormat(trip.endDate))
                        }
                        .font(.headline)
                        
                        Text(trip.name)
                            .font(.title.bold())
                    }
                    
                    Spacer()
                }
                .padding(20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .foregroundStyle(.white)
            .background {
                PhotoView(asset: $trip.photo) { image in
                    image
                        .resizable()
                        .scaledToFill()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .accessibilityLabel("\(trip.name). Start: \(trip.startDate, format: Trip.dateFormat(trip.startDate)); End: \(trip.endDate, format: Trip.dateFormat(trip.endDate)).")
        .listRowSeparator(.hidden, edges: .all)
    }
}

struct TripRowView_Previews: PreviewProvider {
    static var previews: some View {
        TripRowView(trip: .example)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
