//
//  Allergen.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation

struct Allergen: Identifiable, Hashable {
    let id = UUID()
    let name: String

    static let germanNameMap: [String: String] = [
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

    static func germanName(for latinName: String) -> String {
        germanNameMap[latinName] ?? latinName
    }
}
