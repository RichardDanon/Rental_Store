import Foundation



class RentingViewModel: ObservableObject {

    // Mock data for demonstration
    @Published var equipmentGroups: [EquipmentGroup] = [
        EquipmentGroup(id: "1", name: "Baseball", items: [
            Equipment(id: "2", name: "Baseball", availability: .free, usages: []),
            Equipment(id: "3", name: "BaseBall", availability: .rented, usages: [Usage(userName: "Alice", numberOfRentals: 2)])
        ])
    ]

    @Published var users: [User] = [
        User(name: "Alice", phoneNumber: "123-456-7890", email: "alice@email.com", isRenting: true, rentingItems: []),
        User(name: "Bob", phoneNumber: "098-765-4321", email: "bob@email.com", isRenting: false, rentingItems: [])
    ]

    // Fetch an equipment group by its ID
    func fetchEquipmentGroup(byID id: String) -> EquipmentGroup? {
        return equipmentGroups.first { $0.id == id }
    }

    // Fetch a user by name
    func fetchUser(byName name: String) -> User? {
        return users.first { $0.name == name }
    }

    // Create a new equipment group
    func createEquipmentGroup(withName name: String) {
        let newGroup = EquipmentGroup(id: UUID().uuidString, name: name, items: [])
        equipmentGroups.append(newGroup)
    }
}
