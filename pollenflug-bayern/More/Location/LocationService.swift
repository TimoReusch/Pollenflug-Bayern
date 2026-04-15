//
//  LocationService.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation

class LocationService {
    static let shared = LocationService()
    private let url = URL(string: "https://epin.lgl.bayern.de/api/locations")!

    func fetchLocations() async throws -> [Location] {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // JSON enthält mehr als wir brauchen – wir decodieren gezielt
        struct RawLocation: Codable {
            let id: String
            let name: String
        }

        return try JSONDecoder().decode([RawLocation].self, from: data)
            .map { Location(id: $0.id, name: $0.name) }
    }
}
