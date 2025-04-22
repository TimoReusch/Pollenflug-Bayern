//
//  LocationPickerView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import SwiftUI

struct LocationPickerView: View {
    @EnvironmentObject var viewModel: LocationViewModel

    var body: some View {
        if viewModel.locations.isEmpty {
            ProgressView("Lade Standorte...")
                .task {
                    await viewModel.loadLocations()
                }
        } else {
            HStack {
                Picker("", selection: Binding(
                    get: { viewModel.selectedLocation },
                    set: { viewModel.selectedLocation = $0 }
                )) {
                    ForEach(viewModel.locations, id: \.self) { location in
                        Text(location.name).tag(location as Location?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }
}
