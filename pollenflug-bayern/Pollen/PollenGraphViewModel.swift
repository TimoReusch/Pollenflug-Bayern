//
//  PollenGraphViewModel.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation
import SwiftUI

@MainActor
class PollenGraphViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var measurements: [MeasurementData] = []
    @Published var isLoading = false

    func load(
        locationId: String,
        allergens: [String]
    ) async {
        guard !allergens.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await PollenDataService.shared.fetchMeasurements(
                for: locationId,
                allergens: allergens,
                date: selectedDate
            )
            measurements = result
        } catch {
            print("Fehler beim Laden der Messwerte: \(error)")
        }
    }
}
