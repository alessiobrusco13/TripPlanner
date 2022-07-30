//
//  TrippicApp.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import SwiftUI
import Photos

@main
struct TrippicApp: App {
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("photoLibraryAuthorization") var photoLibraryAuthorization = PHAuthorizationStatus.notDetermined
    
    var body: some Scene {
        WindowGroup {
            TripsView()
                .environmentObject(dataController)
                .onChange(of: scenePhase) { phase in
                    if phase == .background {
                        dataController.save()
                    }
                }
                .task {
                    if photoLibraryAuthorization == .notDetermined {
                        photoLibraryAuthorization = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
                    }
                }
        }
    }
}
