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
                        Text("Während der Pollensaison schwankt die Menge an Pollen in der Luft zum Teil sehr stark. Deshalb ist die y-Achse dynamisch und nicht skaliert – das heißt: Sie passt sich je nach Pollenbelastung an. Der höchste Wert auf der Achse kann sich also verändern.")
                        
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
