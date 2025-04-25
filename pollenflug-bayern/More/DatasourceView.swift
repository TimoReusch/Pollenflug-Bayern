//
//  DatenquelleView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 25.04.25.
//

import SwiftUI

struct DatasourceView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Datenquelle")){
                    Text("Die Daten in dieser App werden vom Bayerischen Landesamt für Gesundheit und Lebensmittelsicherheit über eine REST-API bereitgestellt.")
                    Link(destination: URL(string: "https://epin.lgl.bayern.de/schnittstelle")!) {
                        Label("Zur API-Dokumentation", systemImage: "safari")
                    }
                    Link(destination: URL(string: "https://epin.lgl.bayern.de/pollenflug-24h")!) {
                        Label("Aufbereitete Daten zum Pollenflug auf der Website des LGL", systemImage: "safari")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DatasourceView()
    }
}
