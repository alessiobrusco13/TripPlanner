//
//  DataController.swift
//  TripPlanner
//
//  Created by Alessio Garzia Marotta Brusco on 03/05/22.
//

import Combine
import Foundation

class DataController: ObservableObject {
    @Published var trips = [Trip]()

    private let savePath = FileManager.documentsDirectory.appendingPathComponent("trips")
    private var saveSubscription: AnyCancellable?

    init() {
        do {
            let data = try Data(contentsOf: savePath)
            trips = try JSONDecoder().decode([Trip].self, from: data)
        } catch {
            trips = []
        }

        saveSubscription = $trips
            .debounce(for: 5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.save()
            }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(trips)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
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
}
