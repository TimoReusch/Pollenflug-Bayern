//
//  AllergenViewModel.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation
import SwiftUI

@MainActor
class AllergenViewModel: ObservableObject {
    @Published var allAllergens: [Allergen] = []
    @AppStorage("selectedAllergenNames") private var selectedNamesRaw: String = ""

    var selectedAllergens: Set<Allergen> {
        get {
            let names = Set(selectedNamesRaw.split(separator: ",").map { String($0) })
            return Set(allAllergens.filter { names.contains($0.name) })
        }
        set {
            let names = newValue.map { $0.name }
            selectedNamesRaw = names.joined(separator: ",")
        }
    }

    func toggleSelection(for allergen: Allergen) {
        var current = selectedAllergens
        if current.contains(allergen) {
            current.remove(allergen)
        } else {
            current.insert(allergen)
        }
        selectedAllergens = current
    }

    func loadAllergens() async {
        do {
            self.allAllergens = try await AllergenService.shared.fetchAllergens()
        } catch {
            print("Fehler beim Laden der Allergene: \(error)")
        }
    }

    func isSelected(_ allergen: Allergen) -> Bool {
        selectedAllergens.contains(allergen)
    }
    
    // 🔍 Kategorien nach Namen gruppieren
    private var treeNames: Set<String> = ["Betula","Alnus","Corylus","Carpinus","Quercus","Quercus ilex","Populus","Fagus","Ulmus","Fraxinus","Juglans","Tilia","Platanus","Salix","Castanea","Larix","Picea","Pinus","Taxus"]

    private var grassNames: Set<String> = ["Poaceae", "Secale"]

    private var herbNames: Set<String> = ["Artemisia","Ambrosia","Chenopodium","Rumex","Plantago","Urtica","Cruciferae","Galium","Erica"]

    private var shrubNames: Set<String> = ["Aesculus","Acer","Abies","Humulus","Impatiens"]

    private var otherNames: Set<String> = ["Asteraceae","Cyperaceae","Pinaceae","Fungus","Sambucus","Varia"]

    var groupedAllergens: [AllergenCategory] {
        [
            AllergenCategory(name: "Bäume", allergens: allAllergens.filter { treeNames.contains($0.name) }),
            AllergenCategory(name: "Gräser & Getreide", allergens: allAllergens.filter { grassNames.contains($0.name) }),
            AllergenCategory(name: "Kräuter & Unkräuter", allergens: allAllergens.filter { herbNames.contains($0.name) }),
            AllergenCategory(name: "Büsche & Pflanzen", allergens: allAllergens.filter { shrubNames.contains($0.name) }),
            AllergenCategory(name: "Sonstiges", allergens: allAllergens.filter { otherNames.contains($0.name) })
        ]
    }
    
    let allergenNameMap: [String: String] = [
        "Abies": "Tanne",
        "Acer": "Ahorn",
        "Aesculus": "Rosskastanie",
        "Alnus": "Erle",
        "Ambrosia": "Ambrosia",
        "Artemisia": "Beifuß",
        "Asteraceae": "Korbblütler",
        "Betula": "Birke",
        "Carpinus": "Hainbuche",
        "Castanea": "Kastanie",
        "Chenopodium": "Gänsefuß",
        "Corylus": "Hasel",
        "Cruciferae": "Kreuzblütler",
        "Cyperaceae": "Sauergrasgewächse",
        "Erica": "Heidekraut",
        "Fagus": "Buche",
        "Fraxinus": "Esche",
        "Fungus": "Pilze",
        "Galium": "Labkraut",
        "Humulus": "Hopfen",
        "Impatiens": "Springkraut",
        "Juglans": "Walnuss",
        "Larix": "Lärche",
        "Picea": "Fichte",
        "Pinaceae": "Kieferngewächse",
        "Pinus": "Kiefer",
        "Plantago": "Wegerich",
        "Platanus": "Platane",
        "Poaceae": "Gräser",
        "Populus": "Pappel",
        "Quercus": "Eiche",
        "Quercus ilex": "Steineiche",
        "Rumex": "Ampfer",
        "Salix": "Weide",
        "Sambucus": "Holunder",
        "Secale": "Roggen",
        "Taxus": "Eibe",
        "Tilia": "Linde",
        "Ulmus": "Ulme",
        "Urtica": "Brennnessel",
        "Varia": "Sonstiges"
    ]

    func displayName(for allergen: Allergen) -> String {
        if let readable = allergenNameMap[allergen.name] {
            return "\(readable) (\(allergen.name))"
        } else {
            return allergen.name
        }
    }
}
