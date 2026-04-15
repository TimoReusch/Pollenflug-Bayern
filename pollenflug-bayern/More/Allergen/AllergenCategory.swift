//
//  AllergenCategory.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import Foundation

struct AllergenCategory: Identifiable {
    let id = UUID()
    let name: String
    let allergens: [Allergen]
}
