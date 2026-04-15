//
//  LocationViewModel.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation
import SwiftUI

@MainActor
class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @AppStorage("selectedLocationId") var selectedLocationId: String?

    var selectedLocation: Location? {
        get {
            locations.first { $0.id == selectedLocationId }
        }
        set {
            selectedLocationId = newValue?.id
        }
    }

    func loadLocations() async {
        do {
            let fetched = try await LocationService.shared.fetchLocations()
            self.locations = fetched.sorted { $0.name < $1.name }

            // Wenn kein Standort gespeichert ist, wähle den ersten
            if selectedLocationId == nil, let first = self.locations.first {
                selectedLocationId = first.id
            }
        } catch {
            print("Fehler beim Laden: \(error)")
        }
    }
}
