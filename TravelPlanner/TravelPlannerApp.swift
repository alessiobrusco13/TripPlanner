//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI

@main
struct TripPlannerApp: App {
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(dataController)
                    .onChange(of: scenePhase) { phase in
                        if phase == .background {
                            dataController.save()
                        }
                    }
            }
        }
    }
}
