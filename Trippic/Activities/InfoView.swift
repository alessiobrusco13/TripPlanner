//
//  InfoView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 21/07/22.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Spacer()
                        
                        Image("LogoSacroCuore")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        Spacer()
                    }
                    .listRowBackground(EmptyView())
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Text(verbatim: "afdsfgdsgdsflgagipagidsfgpawgpsngag")
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: dismiss.callAsFunction) {
                    Label("Dismiss", systemImage: "xmark")
                        .font(.body.weight(.medium))
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
