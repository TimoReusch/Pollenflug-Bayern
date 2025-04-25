//
//  MoreView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 25.04.25.
//

import SwiftUI

struct MoreView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List{
                NavigationLink("Interpretation der Messwerte"){
                    InterpretationView()
                }
                NavigationLink("Datenquelle"){
                    DatasourceView()
                }
                Link(destination: URL(string: "https://timo-reusch.de/imprint")!) {
                    Label("Impressum", systemImage: "safari")
                }
                Link(destination: URL(string: "https://timo-reusch.de/privacy")!) {
                    Label("Datenschutzerklärung", systemImage: "safari")
                }
            }
            .navigationTitle("Über diese App")
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
    }
}
