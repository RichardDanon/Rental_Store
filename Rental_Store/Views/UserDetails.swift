import SwiftUI

struct UserDetails: View {
    @ObservedObject var viewModel: RentingViewModel
    var userID: String

    var user: User? {
        viewModel.users.first { $0.id == userID }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let user = user {
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
        }
        .navigationBarTitle(user?.name ?? "User Details", displayMode: .inline)
    }
}

struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        // Assuming you have a way to provide a sample user ID for preview
        let sampleUserID = "sampleUserID"

        // Assuming your ViewModel can handle being initialized without actual Firebase data
        let viewModel = RentingViewModel()

        return UserDetails(viewModel: viewModel, userID: sampleUserID)
    }
}

