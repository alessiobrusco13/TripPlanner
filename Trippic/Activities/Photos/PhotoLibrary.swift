//
//  PhotoLibrary.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 10/06/22.
//

import Photos

enum PhotoLibrary {
    @discardableResult
    static func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            print("Photo library access authorized.")
            return true
        case .notDetermined:
            print("Photo library access not determined.")
//            return await checkAuthorization()
            return false
        case .denied:
            print("Photo library access denied.")
            return false
        case .limited:
            print("Photo library access limited.")
            return false
        case .restricted:
            print("Photo library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
}
