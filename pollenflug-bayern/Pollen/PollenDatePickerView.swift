//
//  PollenDatePickerView.swift
//  pollenflug-bayern
//
//  Created by Timo Reusch on 22.04.25.
//

import SwiftUI

struct PollenDatePickerView: View {
    @ObservedObject var graphVM: PollenGraphViewModel

    var body: some View {
        DatePicker(
            selection: $graphVM.selectedDate,
            in: ...Date(),
            displayedComponents: .date
        ) {
            Label("Datum", systemImage: "calendar")
        }
        
    }
}
