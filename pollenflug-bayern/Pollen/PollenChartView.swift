//
//  PollenChartView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import SwiftUI
import Charts

struct PollenChartView: View {
    @ObservedObject var graphVM: PollenGraphViewModel
    @State private var selectedDate: Date?
    @State private var selectedValues: [String: Double] = [:] // polle -> value

    var body: some View {
        Group {
            if graphVM.isLoading {
                ZStack {
                    Color.clear
                    ProgressView("Lade Pollenwerte...")
                        .padding()
                }
                .frame(maxHeight: .infinity)
            } else if graphVM.measurements.isEmpty {
                Text("Keine Daten verfügbar. Neue Messwerte liegen etwa alle drei Stunden vor.")
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(selectedHeaderText)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        if selectedDate != nil {
                            Text("Loslassen für aktuelle Werte")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 8) {
                        ForEach(displayedTiles, id: \.name) { tile in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tile.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)

                                Text("\(Int(tile.value)) Pollen/m³")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                    Chart {
                        ForEach(graphVM.measurements, id: \.polle) { measurement in
                            ForEach(measurement.data, id: \.from) { point in
                                let date = Date(timeIntervalSince1970: point.from)

                                LineMark(
                                    x: .value("Zeit", date),
                                    y: .value("Wert", point.value)
                                )
                                .interpolationMethod(.monotone)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .foregroundStyle(by: .value("Polle", Allergen.germanName(for: measurement.polle)))

                                if let currentSelectedDate = selectedDate,
                                   Calendar.current.isDate(currentSelectedDate, equalTo: date, toGranularity: .minute),
                                   let selectedValue = selectedValues[measurement.polle] {
                                    PointMark(
                                        x: .value("Zeit", date),
                                        y: .value("Wert", selectedValue)
                                    )
                                    .foregroundStyle(by: .value("Polle", Allergen.germanName(for: measurement.polle)))
                                }
                            }
                        }

                        if let currentSelectedDate = selectedDate {
                            RuleMark(x: .value("Zeit", currentSelectedDate))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                                .foregroundStyle(.gray)
                        }
                    }
                    .chartYScale(domain: 0...yAxisUpperBound)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .stride(by: yAxisTickStep)) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .hour, count: 3)) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.hour())
                        }
                    }
                    .chartLegend(position: .bottom, alignment: .leading)
                    .chartOverlay { proxy in
                        GeometryReader { geometryProxy in
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            guard let plotFrame = proxy.plotFrame else { return }
                                            let plotAreaFrame = geometryProxy[plotFrame]
                                            guard plotAreaFrame.contains(value.location) else { return }

                                            let relativeX = value.location.x - plotAreaFrame.origin.x
                                            guard let date: Date = proxy.value(atX: relativeX) else { return }

                                            let allTimestamps = graphVM.measurements.flatMap { measurement in
                                                measurement.data.map(\.from)
                                            }

                                            guard let nearestTimestamp = allTimestamps.min(by: {
                                                abs($0 - date.timeIntervalSince1970) < abs($1 - date.timeIntervalSince1970)
                                            }) else { return }

                                            selectedDate = Date(timeIntervalSince1970: nearestTimestamp)
                                            selectedValues = [:]

                                            for measurement in graphVM.measurements {
                                                if let match = measurement.data.first(where: { $0.from == nearestTimestamp }) {
                                                    selectedValues[measurement.polle] = match.value
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            selectedDate = nil
                                            selectedValues = [:]
                                        }
                                )
                        }
                    }
                    .frame(minHeight: 300)
                }
                .padding()
            }
        }
    }

    private var latestValues: [String: Double] {
        var values: [String: Double] = [:]

        for measurement in graphVM.measurements {
            if let latest = measurement.data.max(by: { $0.from < $1.from }) {
                values[measurement.polle] = latest.value
            }
        }

        return values
    }

    private var currentDisplayValues: [String: Double] {
        if selectedDate != nil, !selectedValues.isEmpty {
            return selectedValues
        }

        return latestValues
    }

    private var displayedTiles: [(name: String, value: Double)] {
        currentDisplayValues
            .map { (name: Allergen.germanName(for: $0.key), value: $0.value) }
            .sorted { $0.name < $1.name }
    }

    private var selectedHeaderText: String {
        if let selectedDate {
            return "Werte um \(selectedDate.formatted(.dateTime.hour().minute())) Uhr"
        }

        return "Aktuellste Messwerte"
    }

    private var maxMeasurementValue: Double {
        let values = graphVM.measurements.flatMap { measurement in
            measurement.data.map(\.value)
        }
        return values.max() ?? 0
    }

    // Stabilere Achse: feste Untergrenze 0, obere Grenze nur in gut lesbaren Stufen.
    private var yAxisUpperBound: Double {
        let steppedBounds: [Double] = [25, 50, 75, 100, 150, 200, 300, 400, 600, 800, 1_000]
        let paddedMaximum = maxMeasurementValue * 1.1

        if let bound = steppedBounds.first(where: { $0 >= paddedMaximum }) {
            return bound
        }

        return (ceil(paddedMaximum / 200) * 200)
    }

    private var yAxisTickStep: Double {
        switch yAxisUpperBound {
        case ...100:
            return 10
        case ...200:
            return 20
        case ...400:
            return 50
        case ...800:
            return 100
        default:
            return 200
        }
    }
}
