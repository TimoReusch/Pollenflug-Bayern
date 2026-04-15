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
                Link(destination: URL(string: "https://github.com/TimoReusch/Pollenflug-Bayern")!) {
                    Label("GitHub", systemImage: "safari")
                }
                Link(destination: URL(string: "https://avenia.cloud/imprint")!) {
                    Label("Impressum", systemImage: "safari")
                }
                Link(destination: URL(string: "https://avenia.cloud/privacy")!) {
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
