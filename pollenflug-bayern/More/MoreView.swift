//
//  MoreView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 25.04.25.
//

import SwiftUI

struct MoreView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var locationVM: LocationViewModel
    @EnvironmentObject private var allergenVM: AllergenViewModel

    var body: some View {
        NavigationStack {
            List {
                Section(footer: Text("Wähle den Messpunkt, der am nächsten zu deinem aktuellen Standort gelegen ist.")) {
                    NavigationLink {
                        AllergenSelectionView()
                            .environmentObject(allergenVM)
                    } label: {
                        Label("Allergene", systemImage: "leaf")
                    }
                    
                    LocationPickerView()
                        .environmentObject(locationVM)
                }

                Section("Information") {
                    NavigationLink("Interpretation der Messwerte") {
                        InterpretationView()
                    }
                    NavigationLink("Datenquelle") {
                        DatasourceView()
                    }
                }
                
                Section("Rechtliches") {
                    
                    Link(destination: URL(string: "https://avenia.cloud/imprint")!) {
                        Label("Impressum", systemImage: "safari")
                    }
                    Link(destination: URL(string: "https://avenia.cloud/privacy")!) {
                        Label("Datenschutzerklärung", systemImage: "safari")
                    }
                }
                
                Section("Pollenflug Bayern ist Open Source!"){
                    Link(destination: URL(string: "https://github.com/TimoReusch/Pollenflug-Bayern")!) {
                        Label("GitHub", systemImage: "safari")
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Schließen")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MoreView()
            .environmentObject(LocationViewModel())
            .environmentObject(AllergenViewModel())
    }
}
