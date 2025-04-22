//
//  PollenDataService.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation

class PollenDataService {
    static let shared = PollenDataService()

    func fetchMeasurements(
        for locationId: String,
        allergens: [String],
        date: Date
    ) async throws -> [MeasurementData] {
        let calendar = Calendar.current

        guard let from = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date) else {
            throw URLError(.badURL)
        }

        let fromTimestamp = Int(from.timeIntervalSince1970)
        let toTimestamp = fromTimestamp + 86400 // 24 Stunden

        var components = URLComponents(string: "https://epin.lgl.bayern.de/api/measurements")!
        print("📡 Request URL:")
        print(components.url?.absoluteString ?? "Ungültige URL")

        print("📅 FROM: \(fromTimestamp) → \(Date(timeIntervalSince1970: TimeInterval(fromTimestamp)))")
        print("📅 TO: \(toTimestamp) → \(Date(timeIntervalSince1970: TimeInterval(toTimestamp)))")
        print("📍 Standort: \(locationId)")
        print("🌾 Allergene: \(allergens)")
        components.queryItems = [
            URLQueryItem(name: "from", value: "\(fromTimestamp)"),
            URLQueryItem(name: "to", value: "\(toTimestamp)"),
            URLQueryItem(name: "locations", value: locationId),
            URLQueryItem(name: "pollen", value: allergens.joined(separator: ","))
        ]

        let url = components.url!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(PollenMeasurementResponse.self, from: data)
        return decoded.measurements
    }
}
