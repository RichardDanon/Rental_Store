import Foundation

enum Availability: String, Codable {
    case rented, free
}

struct Usage: Codable {
    var userName: String
    var numberOfRentals: Int
}

struct Equipment: Codable {
    var id: String
    var name: String
    var availability: Availability
    var usages: [Usage]
}

struct User: Codable {
    var id: String
    var name: String
    var phoneNumber: String
    var email: String
    var isRenting: Bool
    var rentingItems: [Equipment]
}

struct EquipmentGroup: Codable {
    var id: String
    var name: String
    var items: [Equipment]
}
