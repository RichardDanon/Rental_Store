import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: RentingViewModel
    @State private var showAlert = false
    @State private var userToDelete: Int?
    @State private var showEquipmentView = false
    @State private var selectedUserIndex: Int?
    @State private var showUserDetails: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Renters")
                        .font(.system(size: 35))
                        .padding(.leading)

                    ForEach(viewModel.users.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.users[index].name)
                                    .font(.headline)
                                Spacer()

                                Button(action: {
                                    selectedUserIndex = index
                                    showUserDetails = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                }

                                NavigationLink("",
                                    destination: UserDetails(user: viewModel.users[selectedUserIndex ?? 0], viewModel: viewModel),
                                    isActive: $showUserDetails
                                ).opacity(0)

                                Button(action: {
                                    showEquipmentView = true
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }

                                Button(action: {
                                    userToDelete = index
                                    showAlert = true
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding()

                            ForEach(viewModel.users[index].rentingItems, id: \.id) { item in
                                NavigationLink(
                                    destination: EquipmentDetails(equipment: item, viewModel: viewModel),
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
            .background(NavigationLink("", destination: EquipmentView(viewModel: viewModel), isActive: $showEquipmentView))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete User"),
                  message: Text("Are you sure you want to delete this user and all the items they are renting?"),
                  primaryButton: .destructive(Text("Delete")) {
                      if let index = userToDelete {
                          viewModel.users.remove(at: index)
                      }
                  },
                  secondaryButton: .cancel())
        }
        .navigationBarHidden(true)
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: RentingViewModel())
    }
}
