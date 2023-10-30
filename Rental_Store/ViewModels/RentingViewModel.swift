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

// Equipement View
class EquipementViewModel {
    var equipmentGroups: [EquipmentGroup] = []

    // Fetch equipment groups from your model.
    func fetchEquipmentGroups() {
        // Implement fetching logic here and populate equipmentGroups.
    }

    // Create a new equipment group.
    func createEquipmentGroup(groupName: String) {
        // Implement creation logic and add the new group to equipmentGroups.
    }

    // Delete an equipment group.
    func deleteEquipmentGroup(at index: Int) {
        // Implement deletion logic and remove the group at the specified index.
    }

    // Navigate to EquipmentDetails.
    func navigateToEquipmentDetails(equipment: Equipment) {
        // Implement navigation logic to EquipmentDetails view.
    }

    // Navigate to CreateGroup.
    func navigateToCreateGroup() {
        // Implement navigation logic to CreateGroup view.
    }
}


//Equipement Details
class EquipementDetailsViewModel {
    var selectedEquipment: Equipment?

    // Display availability and usages of selected equipment.
    func displayAvailability() -> Availability {
        return selectedEquipment?.availability ?? .free
    }

    func displayUsages() -> [Usage] {
        return selectedEquipment?.usages ?? []
    }

    // Update availability and usages.
    func updateAvailability(newAvailability: Availability) {
        // Implement updating logic for availability.
    }

    func updateUsages(newUsages: [Usage]) {
        // Implement updating logic for usages.
    }

    // Navigate back to EquipementView.
    func navigateBack() {
        // Implement navigation logic to return to EquipementView.
    }
}

//User View
class UserViewModel {
    var users: [User] = []

    // Fetch user data from your model.
    func fetchUserData() {
        // Implement fetching user data logic and populate users.
    }

    // Navigate to UserDetails.
    func navigateToUserDetails(user: User) {
        // Implement navigation logic to UserDetails view.
    }
}

// User Details View
class UserDetailsViewModel {
    var selectedUser: User?

    // Display user details and rented items.
    func displayUserDetails() -> (phoneNumber: String, email: String, isRenting: Bool) {
        let user = selectedUser
        return (user?.phoneNumber ?? "", user?.email ?? "", user?.isRenting ?? false)
    }

    func displayRentedItems() -> [Equipment] {
        return selectedUser?.rentingItems ?? []
    }

    // Update the user's renting status.
    func updateRentingStatus(isRenting: Bool) {
        // Implement updating logic for the user's renting status.
    }

    // Navigate back to UserView.
    func navigateBack() {
        // Implement navigation logic to return to UserView.
    }
}

//Create group view
class CreateGroupViewModel {
    // Create a new equipment group in the model.
    func createNewGroup(groupName: String) {
        // Implement group creation logic in the model.
    }

    // Navigate back to EquipementView.
    func navigateBack() {
        // Implement navigation logic to return to EquipementView.
    }
}
