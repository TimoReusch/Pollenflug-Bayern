//
//  PollenGraphView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import SwiftUI
import Charts

struct PollenGraphView: View {
    @ObservedObject var locationVM: LocationViewModel
    @ObservedObject var allergenVM: AllergenViewModel
    @StateObject var graphVM = PollenGraphViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Belastung für ausgewählte Allergene")
                .font(.headline)
                .padding(.horizontal)

            DatePicker("Datum auswählen", selection: $graphVM.selectedDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(.horizontal)

            Button("Daten laden") {
                print("🟡 Button gedrückt")
                Task {
                    print("🟠 Task gestartet")
                    if let locationId = locationVM.selectedLocation?.id {
                        let allergenNames = allergenVM.selectedAllergens.map { $0.name }
                        print("🟢 Standort: \(locationId)")
                        print("🌿 Allergene: \(allergenNames)")
                        await graphVM.load(locationId: locationId, allergens: allergenNames)
                    } else {
                        print("🔴 Kein Standort ausgewählt")
                    }
                }
            }
            .padding(.horizontal)

            if graphVM.isLoading {
                ProgressView("Lade Pollenwerte...")
                    .padding()
            } else if graphVM.measurements.isEmpty {
                Text("Keine Daten verfügbar")
                    .padding()
            } else {
                ScrollView(.horizontal) {
                    Chart {
                        ForEach(graphVM.measurements, id: \.polle) { m in
                            ForEach(m.data, id: \.from) { point in
                                LineMark(
                                    x: .value("Zeit", Date(timeIntervalSince1970: point.from)),
                                    y: .value("Wert", point.value)
                                )
                                .foregroundStyle(by: .value("Polle", m.polle))
                            }
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
            }

            Spacer()
        }
    }
}
