//
//  RentingViewModel.swift
//  Rental_Store
//
//  Created by Richard on 2023-10-30.
//

import Foundation

class RentingViewModel: ObservableObject {
    @Published var equipmentGroups: [EquipmentGroup] = []
    @Published var users: [User] = []

    init() {
        // Initialize your mock data here
    }
}
