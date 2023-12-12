import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: RentingViewModel
    @State private var showAlert = false
    @State private var userToDeleteID: String?
    @State private var showUserDetails = false
    @State private var selectedUserID: String?
    @State private var showCreateUserView = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Renters")
                            .font(.system(size: 35))
                            .padding(.leading)
                        Spacer()

                        // Button to navigate to CreateUser view
                        Button(action: {
                            showCreateUserView = true
                        }) {
                            Image(systemName: "person.badge.plus")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .padding(.trailing)
                        }
                    }

                    ForEach(viewModel.users, id: \.id) { user in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(user.name)
                                    .font(.headline)
                                Spacer()

                                Button(action: {
                                    selectedUserID = user.id
                                    showUserDetails = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                }

                                NavigationLink("", destination: UserDetails(viewModel: viewModel, userID: user.id), isActive: $showUserDetails).hidden()

                                Button(action: {
                                    userToDeleteID = user.id
                                    showAlert = true
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding()

                            ForEach(user.rentingItems, id: \.id) { item in
                                NavigationLink(
                                    destination: EquipmentDetails(equipment: item, groupID: "someGroupID", viewModel: viewModel),
                                    label: {
                                        Text("\(item.name) #\(item.id)")
                                    }
                                )
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.bottom)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: CreateUser(rentingViewModel: viewModel), isActive: $showCreateUserView) {
                    EmptyView()
                }
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete User"),
                message: Text("Are you sure you want to delete this user and all the items they are renting?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let id = userToDeleteID {
                        viewModel.deleteUser(userID: id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: RentingViewModel())
    }
}
