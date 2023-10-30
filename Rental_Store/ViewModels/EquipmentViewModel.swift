//
//  EquipmentViewModel.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-23.
//

import SwiftUI
import Foundation


class EquipementViewModel: ObservableObject {
    @Published var model: EquipementModel

    init(model: EquipementModel) {
        self.model = model
    }

    // Business logic functions go here
    // For instance, you could have functions to add or remove items, etc.
}

