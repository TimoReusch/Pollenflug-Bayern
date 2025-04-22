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
            VStack {
                LocationPickerView()
                    .environmentObject(locationVM)
                
                Button("Allergene auswählen") {
                    showAllergenSheet = true
                }
                .sheet(isPresented: $showAllergenSheet) {
                    AllergenSelectionView()
                        .environmentObject(allergenVM)
                }

                PollenGraphView(locationVM: locationVM, allergenVM: allergenVM)
            }
        }
}

#Preview {
    ContentView()
}
