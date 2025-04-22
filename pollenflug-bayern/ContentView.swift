//
//  ContentView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationVM = LocationViewModel()
    @StateObject var allergenVM = AllergenViewModel()
    @StateObject var graphVM = PollenGraphViewModel()
    @State private var showAllergenSheet = false

    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Live Messwerte")){
                    PollenDatePickerView(graphVM: graphVM)
                    PollenChartView(graphVM: graphVM)
                }
                
                Section(
                    footer: Text("Wähle den Messpunkt, der am nächsten zu deinem aktuellen Standort gelegen ist.")) {
                    LocationPickerView()
                        .environmentObject(locationVM)

                    
                    Button {
                        showAllergenSheet = true
                    } label: {
                        Label("Allergene", systemImage: "leaf")
                    }
                    .sheet(isPresented: $showAllergenSheet) {
                        AllergenSelectionView()
                            .environmentObject(allergenVM)
                    }
                }
            }
            .navigationTitle(Text("Pollenflug Bayern"))
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await allergenVM.loadAllergens()
        }
        .onChange(of: locationVM.selectedLocation) {
            reloadIfPossible()
        }
        .onChange(of: showAllergenSheet) {
            if !showAllergenSheet {
                // Sheet wurde geschlossen
                reloadIfPossible()
            }
        }
        .onChange(of: graphVM.selectedDate) {
            reloadIfPossible()
        }
    }
    
    func reloadIfPossible() {
        Task {
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

}

#Preview {
    ContentView()
}
