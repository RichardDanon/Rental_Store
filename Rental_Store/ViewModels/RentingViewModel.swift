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
        User(name: "Alice", phoneNumber: "123-456-7890", email: "alice@email.com", isRenting: true, rentingItems: [
            Equipment(id: "3", name: "BaseBall", availability: .rented, usages: [Usage(userName: "Alice", numberOfRentals: 2)])
        ]),
        User(name: "Bob", phoneNumber: "098-765-4321", email: "bob@email.com", isRenting: false, rentingItems: []),
        
        User(name: "Charlie", phoneNumber: "567-890-1234", email: "charlie@email.com", isRenting: false, rentingItems: [])
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
    
    func updateEquipmentUsages(equipment: Equipment, userName: String, numberOfRentals: Int) {
        if let groupIndex = equipmentGroups.firstIndex(where: { group in
            group.items.contains { $0.id == equipment.id }
        }), let equipmentIndex = equipmentGroups[groupIndex].items.firstIndex(where: { $0.id == equipment.id }) {
            equipmentGroups[groupIndex].items[equipmentIndex].usages.append(Usage(userName: userName, numberOfRentals: numberOfRentals))
            equipmentGroups[groupIndex].items[equipmentIndex].availability = .rented
        }
    }

    
    func getNextEquipmentID(forGroup group: EquipmentGroup) -> String {
        if let lastItem = group.items.last,
           let lastIDInt = Int(lastItem.id) {
            return String(lastIDInt + 1)
        } else {
            return "1"
        }
    }
    
    // Delete an equipment from the equipment groups by equipment's id
    func deleteEquipment(equipmentID: String) {
        for (index, group) in equipmentGroups.enumerated() {
            if let itemIndex = group.items.firstIndex(where: { $0.id == equipmentID }) {
                equipmentGroups[index].items.remove(at: itemIndex)
                break
            }
        }
    }

    // Add new equipment to an equipment group by group's name
    func addEquipmentToGroup(groupName: String, equipmentName: String) {
        if let index = equipmentGroups.firstIndex(where: { $0.name == groupName }) {
            let newItem = Equipment(id: UUID().uuidString, name: equipmentName, availability: .free, usages: [])
            equipmentGroups[index].items.append(newItem)
        }
    }
}
