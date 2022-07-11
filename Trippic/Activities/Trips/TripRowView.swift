//
//  TripRowView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

struct TripRowView: View {
    @ObservedObject var trip: Trip

    var dateFormat: Date.FormatStyle {
        .dateTime.day().month()
    }

    var body: some View {
        NavigationLink {
            TripView(trip: trip)
        } label: {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 5) {
                            Text(trip.startDate, format: dateFormat)
                            
                            Image(systemName: "arrow.right")
                                .font(.caption.weight(.heavy))
                            
                            Text(trip.endDate, format: dateFormat)
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
        .listRowSeparator(.hidden, edges: .all)
        .tag(trip)
    }
}

struct TripRowView_Previews: PreviewProvider {
    static var previews: some View {
        TripRowView(trip: .example)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
