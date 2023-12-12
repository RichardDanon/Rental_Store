import SwiftUI

struct EquipmentDetails: View {
    @State var equipment: Equipment
    @State private var selectedAvailability: Availability
    @State private var showingRentPopup = false
    @State private var showingDeleteAlert = false
    @ObservedObject var viewModel: RentingViewModel
    @State private var selectedUser: User?
    @State private var numberOfRentals: Int = 0
    @Environment(\.presentationMode) var presentationMode
    var groupID: String

    init(equipment: Equipment, groupID: String, viewModel: RentingViewModel) {
        _equipment = State(initialValue: equipment)
        _selectedAvailability = State(initialValue: equipment.availability)
        self.groupID = groupID
        self.viewModel = viewModel

        if let lastUsage = equipment.usages.last {
            _selectedUser = State(initialValue: viewModel.fetchUser(byName: lastUsage.userName))
            _numberOfRentals = State(initialValue: lastUsage.numberOfRentals)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(equipment.name)")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()

                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(title: Text("Delete Item"),
                          message: Text("Are you sure you want to delete this item?"),
                          primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteEquipment(groupID: groupID, equipmentID: equipment.id)
                            presentationMode.wrappedValue.dismiss()
                          },
                          secondaryButton: .cancel())
                }
                .padding(.trailing, 20)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                Text("Availability")
                    .font(.headline)
                    .foregroundColor(.primary)
                Picker("", selection: $selectedAvailability) {
                    Text("Free").tag(Availability.free)
                    Text("Rented").tag(Availability.rented)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Usages")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Last User: \(selectedUser?.name ?? "None")")
                Text("Number of Rentals: \(numberOfRentals)")

                Button(action: {
                    showingRentPopup = true
                }) {
                    Text("Rent")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
            .shadow(radius: 5)
            .padding([.horizontal, .bottom], 20)

            Spacer()
        }
        .padding()
        .actionSheet(isPresented: $showingRentPopup) {
            ActionSheet(title: Text("Choose a Renter"), buttons: viewModel.users.map { user in
                .default(Text(user.name)) {
                    rentEquipment(to: user)
                }
            } + [.cancel()])
        }
    }

    private func rentEquipment(to user: User) {
        selectedUser = user
        numberOfRentals += 1
        selectedAvailability = .rented
        var updatedEquipment = equipment
        updatedEquipment.availability = selectedAvailability
        updatedEquipment.usages.append(Usage(userName: user.name, numberOfRentals: numberOfRentals))

        viewModel.updateEquipmentDetails(groupID: groupID, updatedEquipment: updatedEquipment)
        
        
    }
}

struct EquipmentDetails_Previews: PreviewProvider {
    static var previews: some View {
        let mockUsage: [Usage] = [Usage(userName: "Alice", numberOfRentals: 1)]
        let mockEquipment = Equipment(id: "1", name: "Mock Equipment", availability: .free, usages: mockUsage)
        let groupID = "mockGroupID"
        
        let viewModel = RentingViewModel()
        
        return EquipmentDetails(equipment: mockEquipment, groupID: groupID, viewModel: viewModel)
    }
}
