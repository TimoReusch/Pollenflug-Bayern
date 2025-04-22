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
}
