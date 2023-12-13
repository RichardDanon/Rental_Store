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
    
    
    func updateEquipmentUsages(groupID: String, equipmentID: String, userName: String, numberOfRentals: Int) {
        let usage = Usage(userName: userName, numberOfRentals: numberOfRentals)
        
        let documentRef = Firestore.firestore().collection("equipmentGroups/\(groupID)/items").document(equipmentID)
        documentRef.updateData([
            "usages": FieldValue.arrayUnion([["userName": userName, "numberOfRentals": numberOfRentals]])
        ]) { error in
            if let error = error {
                print("Error updating usages: \(error.localizedDescription)")
            } else {
                print("Usages successfully updated")
            }
        }
    }


    func updateEquipmentDetails(groupID: String, updatedEquipment: Equipment) {
        let documentRef = Firestore.firestore().collection("equipmentGroups/\(groupID)/items").document(updatedEquipment.id)
        do {
            try documentRef.setData(from: updatedEquipment) { error in
                if let error = error {
                    print("Error updating equipment details: \(error.localizedDescription)")
                } else {
                    print("Equipment details successfully updated")
                }
            }
        } catch let error {
            print("Error encoding equipment: \(error)")
        }
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

extension RentingViewModel {

    // Delete an entire equipment group and all its items
    func deleteEquipmentGroup(groupID: String) {
        // Step 1: Delete all items within the group
        equipmentGroupRepository.deleteCollection(collectionPath: "equipmentGroups/\(groupID)/items", batchSize: 100) {
            // Step 2: Once all items are deleted, delete the group document itself
            self.equipmentGroupRepository.deleteDocument(from: "equipmentGroups", documentID: groupID)

            // Step 3: Update local state
            if let index = self.equipmentGroups.firstIndex(where: { $0.id == groupID }) {
                self.equipmentGroups.remove(at: index)
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }

    // Delete a single equipment item from a group
    func deleteEquipmentItem(groupID: String, equipmentID: String) {
        // Delete the document for the equipment item
        equipmentGroupRepository.deleteDocument(from: "equipmentGroups/\(groupID)/items", documentID: equipmentID)

        // Update local state
        if let groupIndex = self.equipmentGroups.firstIndex(where: { $0.id == groupID }),
           let itemIndex = self.equipmentGroups[groupIndex].items.firstIndex(where: { $0.id == equipmentID }) {
            self.equipmentGroups[groupIndex].items.remove(at: itemIndex)
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}



extension RentingViewModel {

    // Function to match equipment to users based on the equipment's last usage
    func matchAndAssignEquipmentToUsers(completion: @escaping () -> Void) {
        // First, fetch all equipment groups
        fetchEquipmentGroups {
            // Then, fetch all users
            self.fetchUsers {
                // Now that we have both users and equipment, we can match them
                self.assignEquipmentToUsers()
                // After assignment, update the UI
                completion()
            }
        }
    }

    // Helper function to assign equipment to users
    private func assignEquipmentToUsers() {
        // Clear previous assignments to avoid duplication
        for index in users.indices {
            users[index].rentingItems.removeAll()
        }
        
        // Iterate over each equipment group and their items
        for group in equipmentGroups {
            for item in group.items {
                // Check if the item has a usage record
                if let latestUsage = item.usages.last {
                    // Find the user with the matching name and assign the equipment to them
                    if let userIndex = users.firstIndex(where: { $0.name == latestUsage.userName }) {
                        users[userIndex].rentingItems.append(item)
                    }
                }
            }
        }
        // Update the renting status for each user
        updateUsersRentingStatus()
    }

    // Helper function to fetch equipment groups
    private func fetchEquipmentGroups(completion: @escaping () -> Void) {
        equipmentGroupRepository.fetchCollection(collectionPath: "equipmentGroups") { (groups: [EquipmentGroup]) in
            DispatchQueue.main.async {
                self.equipmentGroups = groups
                completion()
            }
        }
    }

    // Helper function to fetch users
    private func fetchUsers(completion: @escaping () -> Void) {
        userRepository.fetchCollection(collectionPath: "users") { (users: [User]) in
            DispatchQueue.main.async {
                self.users = users
                completion()
            }
        }
    }

    // Function to update the renting status for each user
    private func updateUsersRentingStatus() {
        for i in 0..<users.count {
            users[i].isRenting = !users[i].rentingItems.isEmpty
        }
        // Notify the view to update
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
