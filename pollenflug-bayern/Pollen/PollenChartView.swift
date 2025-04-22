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
                ProgressView("Lade Pollenwerte...")
                    .padding()
            } else if graphVM.measurements.isEmpty {
                Text("Keine Daten verfügbar. Neue Messwerte liegen etwa alle drei Stunden vor.")
                    
            } else {
                Chart {
                    ForEach(graphVM.measurements, id: \.polle) { m in
                        ForEach(m.data, id: \.from) { point in
                            let date = Date(timeIntervalSince1970: point.from)
                            
                            LineMark(
                                x: .value("Zeit", date),
                                y: .value("Wert", point.value)
                            )
                            .foregroundStyle(by: .value("Polle", m.polle))
                            
                            // Tooltip nur, wenn polle & Zeit passen
                            if let selDate = selectedDate,
                               Calendar.current.isDate(selDate, equalTo: date, toGranularity: .minute),
                               let val = selectedValues[m.polle] {
                                PointMark(x: .value("Zeit", date), y: .value("Wert", val))
                                    .annotation(position: .top, alignment: .center) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("🌿 \(m.polle)")
                                            Text("⏱️ \(selDate.formatted(.dateTime.hour().minute()))")
                                            Text("📈 \(Int(val)) Pollen/m³")
                                        }
                                        .font(.caption2)
                                        .padding(6)
                                        .background(Color(.systemBackground).opacity(0.9))
                                        .cornerRadius(6)
                                        .shadow(radius: 3)
                                    }
                            }
                        }
                    }
                    
                    // RuleMark bei aktiver Auswahl
                    if let selDate = selectedDate {
                        RuleMark(x: .value("Zeit", selDate))
                            .lineStyle(StrokeStyle(dash: [4]))
                            .foregroundStyle(.gray)
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x) {
                                            // Nahegelegenes timestamp finden
                                            let allTimestamps = graphVM.measurements.flatMap { $0.data.map(\.from) }
                                            if let nearest = allTimestamps.min(by: { abs($0 - date.timeIntervalSince1970) < abs($1 - date.timeIntervalSince1970) }) {
                                                let nearestDate = Date(timeIntervalSince1970: nearest)
                                                selectedDate = nearestDate
                                                selectedValues = [:]
                                                
                                                for m in graphVM.measurements {
                                                    if let match = m.data.first(where: { $0.from == nearest }) {
                                                        selectedValues[m.polle] = match.value
                                                    }
                                                }
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
                .padding()
            }
        }
    }
}
