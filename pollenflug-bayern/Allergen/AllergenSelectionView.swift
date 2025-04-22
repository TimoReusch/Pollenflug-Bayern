//
//  AllergenSelectionView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import SwiftUI

struct AllergenSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AllergenViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.groupedAllergens) { category in
                    Section(header: Text(category.name)) {
                        ForEach(category.allergens) { allergen in
                            Toggle(viewModel.displayName(for: allergen), isOn: Binding(
                                get: { viewModel.isSelected(allergen) },
                                set: { _ in viewModel.toggleSelection(for: allergen) }
                            ))
                        }
                    }
                }
            }
            .navigationTitle("Allergene")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.loadAllergens()
            }
        }
    }
}
