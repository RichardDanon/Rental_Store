//
//  UserDetails.swift
//  Rental_Store
//
//  Created by Richard on 2023-10-30.
//

import SwiftUI

struct UserDetails: View {
    var user: User
     var viewModel: RentingViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.largeTitle)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Phone Number")
                    Spacer()
                    Text(user.phoneNumber)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(user.email)
                }
                
                HStack {
                    Text("Is Renting")
                    Spacer()
                    if user.isRenting {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                
                Divider().padding(.vertical, 10)
                
                Text("Items Being Rented")
                    .font(.headline)
                
                ForEach(user.rentingItems, id: \.id) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("Id: \(item.id)")
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitle(user.name, displayMode: .inline)
    }
}

struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        let mockUsage: [Usage] = [Usage(userName: "Alice", numberOfRentals: 1)]
        let mockEquipment = Equipment(id: "1", name: "Mock Equipment", availability: .free, usages: mockUsage)
        
        let mockUser = User(name: "Alice", phoneNumber: "123-456-7890", email: "alice@email.com", isRenting: true, rentingItems: [mockEquipment])
        
        let viewModel = RentingViewModel()

        return UserDetails(user: mockUser, viewModel: viewModel)
    }
}
