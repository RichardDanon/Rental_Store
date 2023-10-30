//
//  EquipementModel.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-23.
//

import Foundation

struct Equipment {
    var id: String
    var name: String
    var availability: Availability
    var usages: [Usage]
}

enum Availability {
    case rented, free
}

struct Usage {
    var userName: String
    var numberOfRentals: Int
}

struct User {
    var name : String
    var phoneNumber: String
    var email: String
    var isRenting: Bool
    var rentingItems: [Equipment]
}

struct EquipmentGroup {
    var id: String
    var name: String
    var items: [Equipment]
}
