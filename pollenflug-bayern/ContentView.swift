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
    @State private var showAllergenSheet = false

    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Einstellungen")) {
                    HStack {
                        Text("Standort")
                        Spacer()
                        LocationPickerView()
                            .environmentObject(locationVM)
                    }
                    
                    
                    Button("Allergene auswählen") {
                        showAllergenSheet = true
                    }
                    .sheet(isPresented: $showAllergenSheet) {
                        AllergenSelectionView()
                            .environmentObject(allergenVM)
                    }
                }
                Section(header: Text("Belastung für ausgewählte Allergene")){
                    PollenGraphView(locationVM: locationVM, allergenVM: allergenVM)
                }
            }
            
            .navigationTitle(Text("Pollenflug Bayern"))
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ContentView()
}
