//
//  UserDetails.swift
//  Rental_Store
//
//  Created by Richard on 2023-10-30.
//

//
//  UserDetails.swift
//  Rental_Store
//
//  Created by Richard on 2023-10-30.
//

import SwiftUI

struct UserDetails: View {
    let user: User

    var body: some View {
        Text("Hello, \(user.name)")
    }
}

struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        let mockUser = User(
            name: "John",
            phoneNumber: "555-555-5555",
            email: "john.doe@example.com",
            isRenting: true,
            rentingItems: [
                Equipment(id: "1", name: "Bike", availability: .free, usages: []),
                Equipment(id: "2", name: "Tent", availability: .rented, usages: []),
                Equipment(id: "3", name: "Kayak", availability: .free, usages: [])
            ]
        )

        return UserDetails(user: mockUser)
    }
}

