//
//  DataController.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import Combine
import Photos
import SwiftUI

class DataController: ObservableObject {
    enum PhotoError: LocalizedError {
        case assetNotFound
        case requestCancelled
        case other(Error?)
    }
    
    @Published var trips = [Trip]()
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("trips")
    private var saveSubscription: AnyCancellable?
    
    private let imageManager = PHCachingImageManager()
    
    private lazy var imageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        return options
    }()
    
    var favoriteImages: [PhotoAsset] {
        trips
            .map(\.locations)
            .joined()
            .map(\.photos)
            .joined()
            .filter(\.isFavorite)
    }
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            trips = try JSONDecoder().decode([Trip].self, from: data)
        } catch {
            trips = []
            print(error)
        }
        
        saveSubscription = $trips
            .debounce(for: 5, scheduler: RunLoop.main)
            .sink { _ in
                self.save()
            }
        
        imageManager.allowsCachingHighQualityImages = true
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(trips)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func add(_ newTrip: Trip) {
        trips.append(newTrip)
    }
    
    func delete(_ offsets: IndexSet) {
        let sorted = offsets.map { trips.sorted()[$0] }
        
        for trip in sorted {
            guard let index = trips.firstIndex(of: trip) else { continue }
            trips.remove(at: index)
        }
    }
    
    func delete(_ trip: Trip) {
        guard let index = trips.firstIndex(of: trip) else { return }
        trips.remove(at: index)
    }
    
    func location(for photo: PhotoAsset) -> Location? {
        let locations = Array(trips.map(\.locations).joined())
        var locationsPhotos = [(Location, Set<PhotoAsset>)]()
        
        for location in locations {
            locationsPhotos.append((location, Set(location.photos)))
        }
        
        for (location, photos) in locationsPhotos {
            if photos.contains(photo) {
                return location
            }
        }
        
        return nil
    }
    
    func trip(for location: Location) -> Trip? {
        var tripsLocations = [(Trip, Set<Location>)]()
        
        for trip in trips {
            tripsLocations.append((trip, Set(trip.locations)))
        }
        
        for (trip, locations) in tripsLocations {
            if locations.contains(location) {
                return trip
            }
        }
        
        return nil
    }
    
    func startCaching(_ assets: [PhotoAsset], targetSize: CGSize) {
        guard !assets.isEmpty else { return }
        let phAssets = assets.compactMap { $0.phAsset }
        
        imageManager.startCachingImages(for: phAssets, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions)
    }
    
    func stopCaching(_ assets: [PhotoAsset], targetSize: CGSize) {
        guard !assets.isEmpty else { return }
        let phAssets = assets.compactMap { $0.phAsset }
        
        imageManager.stopCachingImages(for: phAssets, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions)
    }
    
    func stopCaching() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
    func requestImage(for asset: PhotoAsset, targetSize: CGSize, completion: @escaping @Sendable (Result<Image, PhotoError>) -> Void) {
        guard let phAsset = asset.phAsset else {
            completion(.failure(.assetNotFound))
            return
        }
        
        imageManager.requestImage(for: phAsset, targetSize: targetSize, contentMode: .aspectFill, options: imageRequestOptions) { image, info in
            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(.other(error)))
                return
            } else if let cancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
                completion(.failure(.requestCancelled))
                return
            } else if let image = image {
                completion(.success(Image(uiImage: image)))
                return
            } else {
                completion(.failure(.other(nil)))
                return
            }
        }
    }
    
    func path(for location: Location) -> (tripIndex: Int, locationIndex: Int)? {
        guard let trip = trip(for: location) else { return nil }
        guard let tripIndex = trips.firstIndex(of: trip) else { return nil }
        guard let locationIndex = trip.locations.firstIndex(of: location) else { return nil }
        return (tripIndex, locationIndex)
    }
    
    func path(for photo: PhotoAsset) -> (tripIndex: Int, locationIndex: Int, photoIndex: Int)? {
        guard let location = location(for: photo) else { return nil }
        guard let locationPath = path(for: location) else { return nil }
        guard let photoIndex = location.photos.firstIndex(of: photo) else { return nil }
        return (locationPath.tripIndex, locationPath.locationIndex, photoIndex)
    }
}
