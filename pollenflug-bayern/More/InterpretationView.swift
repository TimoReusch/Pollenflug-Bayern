//
//  InterpretationView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 25.04.25.
//

import SwiftUI

struct InterpretationView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Informationen zur Interpretation und Darstellung der Pollenkonzentration")){
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Während der Pollensaison schwankt die Menge an Pollen in der Luft zum Teil sehr stark. Die y-Achse startet deshalb immer bei 0 und wird für eine bessere Vergleichbarkeit in festen, gut lesbaren Stufen dargestellt. Bei deutlich höheren Werten erweitert sich der Wertebereich automatisch.")
                        
                        Text("Jeder Mensch mit einer Pollenallergie reagiert unterschiedlich stark auf Pollen. Ab welcher Konzentration Symptome auftreten, ist individuell verschieden. Deshalb lässt sich kein allgemeingültiger Schwellenwert für allergische Reaktionen angeben.")
                        
                        Text("Wir richten uns nach der Empfehlung des Bayerischen Landesamtes für Gesundheit und Lebensmittelsicherheit und geben daher hier keine Schwellwerte an. Beobachte am besten regelmäßig die Entwicklung der Pollenkonzentration und vergleiche sie mit deinen eigenen Symptomen. So bekommst du ein besseres Gefühl dafür, ab wann bei dir Beschwerden auftreten.")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InterpretationView()
    }
}
