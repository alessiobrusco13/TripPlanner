//
//  InfoView.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 21/07/22.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    let gitHubURL = URL(string: "https://www.github.com/alessiobrusco13/Trippic")!
    
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
                    VStack {
                        Text(sections[0])
                        
                        Divider()
                        
                        Text(sections[1])
                        
                        Divider()
                        
                        Text(sections[2])
                        
                        Divider()
                        
                        Text(sections[3])
                    }
                    .padding()
                }
                
                Section {
                    VStack {
                        Spacer()
                        
                        Link(destination: gitHubURL) {
                            Label {
                                Text(verbatim: "GitHub Repository")
                            } icon: {
                                Image("GitHub")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.body)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(EmptyView())
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
    
    var sections: [String] {
        infoText.components(separatedBy: "\n\n")
    }
    
    var infoText: String {
        String(
            localized: """
        Trippic! is a digital diary that lets you document and preserve over time the experiences lived during your trips, through snapshots of landscapes, places and encounters dear to your heart, and the thoughts and sensations you experienced.
        
        The app was born from an idea developed by high school students attending Istituto Sacro Cuore in Naples, following Apple’s guidelines from the ”App design diary” workbook, which led the groups into the phases of brainstorming, planning and evaluation of the prototype.
        
        The final phase of the project, consisting in the development of the app and the subsequent stages of testing, improvement of the user experience and publication on the App Store, was handled by the student Alessio Garzia Marotta Brusco with the coordination of teacher Domenico Caggiano and the help of the students of the “App Development with Swift” course.
        
        The app, made with the SwiftUI and MapKit frameworks for locating trips, has been made compliant with Apple's Human Interface Guidelines, and fully localized in Italian and English with support for VoiceOver.
        """,
            defaultValue: ""
        )
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
