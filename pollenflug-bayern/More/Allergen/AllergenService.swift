//
//  AllergenService.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation

class AllergenService {
    static let shared = AllergenService()
    private let url = URL(string: "https://epin.lgl.bayern.de/api/pollen")!

    func fetchAllergens() async throws -> [Allergen] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let rawNames = try JSONDecoder().decode([String].self, from: data)
        return rawNames.map { Allergen(name: $0) }
    }
}
