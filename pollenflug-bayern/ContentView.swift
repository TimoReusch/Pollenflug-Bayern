//
//  ContentView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("selectedAllergenNames") private var selectedNamesRaw: String = ""

    @StateObject private var locationVM = LocationViewModel()
    @StateObject private var allergenVM = AllergenViewModel()
    @StateObject private var graphVM = PollenGraphViewModel()

    @State private var showMoreSheet = false
    @State private var showSettingsSheet = false

    var body: some View {
        NavigationStack {
            List {
                if !hasSelectedAllergens {
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Bitte wähle mindestens ein Allergen aus, um Daten anzuzeigen.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Button {
                                showSettingsSheet = true
                            } label: {
                                Label("Allergene auswählen", systemImage: "leaf")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                if hasSelectedAllergens {
                    Section {
                        if liveTiles.isEmpty {
                            Text("Für heute liegen noch keine Daten vor.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(liveTiles, id: \.name) { tile in
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(tile.name)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)

                                        Text("\(Int(tile.value))")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .lineLimit(1)

                                        Text("Pollen/m³")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }

                    Section(header: Text("Live Messwerte")) {
                        PollenChartView(graphVM: graphVM)
                        PollenDatePickerView(graphVM: graphVM)
                    }
                }
            }
            .navigationTitle(Text(currentDateTitle))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettingsSheet = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Messpunkt und Allergene")
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showMoreSheet = true
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showMoreSheet) {
                MoreView()
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsSheetView()
                    .environmentObject(locationVM)
                    .environmentObject(allergenVM)
            }
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await locationVM.loadLocations()
            await allergenVM.loadAllergens()
            reloadIfPossible()
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(300))
                reloadLiveIfPossible()
            }
        }
        .onChange(of: locationVM.selectedLocation) {
            reloadIfPossible()
        }
        .onChange(of: selectedNamesRaw) {
            reloadIfPossible()
        }
        .onChange(of: graphVM.selectedDate) {
            reloadIfPossible()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                reloadIfPossible()
            }
        }
    }

    private var currentDateTitle: String {
        Date().formatted(.dateTime.day().month(.wide).year())
    }

    private var selectedAllergenNames: [String] {
        selectedNamesRaw
            .split(separator: ",")
            .map(String.init)
    }

    private var hasSelectedAllergens: Bool {
        !selectedAllergenNames.isEmpty
    }

    private var liveTiles: [(name: String, value: Double)] {
        graphVM.liveMeasurements
            .compactMap { measurement in
                guard let latest = measurement.data.max(by: { $0.from < $1.from }) else { return nil }
                return (name: Allergen.germanName(for: measurement.polle), value: latest.value)
            }
            .sorted { $0.name < $1.name }
    }

    private func reloadIfPossible() {
        Task { @MainActor in
            guard let locationId = locationVM.selectedLocation?.id,
                  !selectedAllergenNames.isEmpty else {
                graphVM.measurements = []
                graphVM.liveMeasurements = []
                return
            }

            await graphVM.load(locationId: locationId, allergens: selectedAllergenNames)
            await graphVM.loadLive(locationId: locationId, allergens: selectedAllergenNames)
        }
    }

    private func reloadLiveIfPossible() {
        Task { @MainActor in
            guard let locationId = locationVM.selectedLocation?.id,
                  !selectedAllergenNames.isEmpty else {
                graphVM.liveMeasurements = []
                return
            }

            await graphVM.loadLive(locationId: locationId, allergens: selectedAllergenNames)
        }
    }
}

private struct SettingsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var locationVM: LocationViewModel
    @EnvironmentObject private var allergenVM: AllergenViewModel

    @State private var showAllergenSheet = false

    var body: some View {
        NavigationStack {
            List {
                Section("Messpunkt") {
                    LocationPickerView()
                        .environmentObject(locationVM)
                }

                Section("Allergene") {
                    Button {
                        showAllergenSheet = true
                    } label: {
                        Label("Allergene auswählen", systemImage: "leaf")
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAllergenSheet) {
                AllergenSelectionView()
                    .environmentObject(allergenVM)
            }
        }
    }
}

#Preview {
    ContentView()
}
