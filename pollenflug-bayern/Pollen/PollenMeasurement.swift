//
//  PollenMeasurement.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation

struct PollenMeasurementResponse: Codable {
    let from: TimeInterval
    let to: TimeInterval
    let measurements: [MeasurementData]
}

struct MeasurementData: Codable {
    let polle: String
    let location: String
    let data: [MeasurementPoint]
}

struct MeasurementPoint: Codable {
    let from: TimeInterval
    let to: TimeInterval
    let value: Double
}
