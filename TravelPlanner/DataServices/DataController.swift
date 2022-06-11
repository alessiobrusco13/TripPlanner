//
//  DataController.swift
//  TripPlanner
//s
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class DataController: ObservableObject {
    @Published var trips = [Trip]()
    @Published var photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)

    private let savePath = FileManager.documentsDirectory.appendingPathComponent("trips")
    private var saveSubscription: AnyCancellable?
    
    var isPhotosLoaded = false

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
    
    func loadPhotos() async {
        guard !isPhotosLoaded else { return }
        
        let authorized = await PhotoLibrary.checkAuthorization()
        guard authorized else { return }
        
        Task {
            do {
                try await self.photoCollection.load()
            } catch {
                print(error.localizedDescription)
            }
            
            self.isPhotosLoaded = true
        }
    }

    func add(_ newTrip: Trip) {
        trips.append(newTrip)
    }

    func delete(_ offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
    }

    func delete(_ selected: Set<Trip>) {
        trips.removeAll(where: selected.contains)
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
}
