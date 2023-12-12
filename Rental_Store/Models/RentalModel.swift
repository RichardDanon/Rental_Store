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

extension Equipment {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "", code: 100, userInfo: [NSLocalizedDescriptionKey: "Could not convert to dictionary"])
        }
        return dictionary
    }
}
