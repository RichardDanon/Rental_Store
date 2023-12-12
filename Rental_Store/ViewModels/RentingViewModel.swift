import Foundation
import FirebaseFirestore

class RentingViewModel: ObservableObject {
    @Published var equipmentGroups: [EquipmentGroup] = []
    @Published var users: [User] = []
    
    
    private var equipmentGroupRepository = FirebaseRepository()
    private var userRepository = FirebaseRepository()
    
    init() {
        fetchEquipmentGroups()
        fetchUsers()
    }
    
    private func fetchEquipmentGroups() {
        equipmentGroupRepository.fetchCollection(collectionPath: "equipmentGroups") { [weak self] (groups: [EquipmentGroup]) in
            DispatchQueue.main.async {
                self?.equipmentGroups = groups
                self?.fetchItemsForAllGroups()
            }
        }
    }
    
    private func fetchItemsForAllGroups() {
        let groupDispatchGroup = DispatchGroup()
        
        for (index, group) in equipmentGroups.enumerated() {
            groupDispatchGroup.enter()
            fetchItemsForGroup(groupID: group.id) { items in
                DispatchQueue.main.async {
                    self.equipmentGroups[index].items = items
                    groupDispatchGroup.leave()
                }
            }
        }
        
        groupDispatchGroup.notify(queue: .main) {
            self.objectWillChange.send()
        }
    }
    
    func addEquipmentToGroup(groupID: String) {
        fetchLatestEquipmentID(groupID: groupID) { latestID in
            let newEquipmentID = self.incrementID(latestID)
            let equipmentName = "\(self.getGroupNameByID(groupID) ?? "Item") #\(newEquipmentID)"
            let newEquipment = Equipment(id: newEquipmentID, name: equipmentName, availability: .free, usages: [])
            
            self.equipmentGroupRepository.addDocument(to: "equipmentGroups/\(groupID)/items", document: newEquipment)
            
            if let groupIndex = self.equipmentGroups.firstIndex(where: { $0.id == groupID }) {
                DispatchQueue.main.async {
                    self.equipmentGroups[groupIndex].items.append(newEquipment)
                }
            }
        }
    }
    
    private func fetchItemsForGroup(groupID: String, completion: @escaping ([Equipment]) -> Void) {
        equipmentGroupRepository.fetchCollection(collectionPath: "equipmentGroups/\(groupID)/items") { (items: [Equipment]) in
            completion(items)
        }
    }
    
    private func fetchUsers() {
        userRepository.fetchCollection(collectionPath: "users") { (users: [User]) in
            self.users = users
        }
    }
    
    func createEquipmentGroup(withName name: String) {
        let newGroup = EquipmentGroup(id: UUID().uuidString, name: name, items: [])
        equipmentGroupRepository.addDocument(to: "equipmentGroups", document: newGroup)
    }
    
    //    func addEquipmentToGroup(groupID: String) {
    //        fetchLatestEquipmentID(groupID: groupID) { latestID in
    //            let newEquipmentID = self.incrementID(latestID)
    //            let equipmentName = "\(self.getGroupNameByID(groupID) ?? "Item") #\(newEquipmentID)"
    //            let newEquipment = Equipment(id: newEquipmentID, name: equipmentName, availability: .free, usages: [])
    //            self.equipmentGroupRepository.addDocument(to: "equipmentGroups/\(groupID)/equipment", document: newEquipment)
    //        }
    //    }
    
    func createUser(name: String, phoneNumber: String, email: String) {
        let newUser = User(id: UUID().uuidString, name: name, phoneNumber: phoneNumber, email: email, isRenting: false, rentingItems: [])
        userRepository.addDocument(to: "users", document: newUser)
    }
    
    // Additional helper methods...
    private func getGroupNameByID(_ groupID: String) -> String? {
        return equipmentGroups.first { $0.id == groupID }?.name
    }
    
    
    func deleteUser(userID: String) {
        userRepository.deleteDocument(from: "users", documentID: userID)
        if let index = users.firstIndex(where: { $0.id == userID }) {
            users.remove(at: index)
        }
    }
    
    func updateEquipmentUsages(groupID: String, equipment: Equipment, userName: String, numberOfRentals: Int) {
        var updatedEquipment = equipment
        // Update the usages logic
        // Then update the equipment in Firestore
        equipmentGroupRepository.updateDocument(in: "equipmentGroups/\(groupID)/equipment", documentID: equipment.id, document: updatedEquipment)
    }
    
    // Update isRenting status for a user
    func updateIsRentingStatusForUser(userName: String) {
        if let userIndex = users.firstIndex(where: { $0.name == userName }) {
            users[userIndex].isRenting = !users[userIndex].rentingItems.isEmpty
        }
    }
    
    func fetchUser(byName name: String) -> User? {
        return users.first { $0.name == name }
    }
    
    // Delete an equipment from the equipment groups by equipment's id
    func deleteEquipment(groupID: String, equipmentID: String) {
        equipmentGroupRepository.deleteDocument(from: "equipmentGroups/\(groupID)/equipment", documentID: equipmentID)
    }
    
    private func incrementID(_ id: String) -> String {
        if let idNumber = Int(id) {
            return String(idNumber + 1)
        } else {
            return UUID().uuidString // Fallback if ID is not numeric
        }
    }
    
    private func fetchLatestEquipmentID(groupID: String, completion: @escaping (String) -> Void) {
        let collectionRef = Firestore.firestore().collection("equipmentGroups/\(groupID)/items")
        collectionRef.order(by: "id", descending: true).limit(to: 1).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                completion("0") // Default value if fetch fails
                return
            }
            
            let latestID = snapshot?.documents.first?.data()["id"] as? String ?? "0"
            completion(latestID)
        }
    }
}
