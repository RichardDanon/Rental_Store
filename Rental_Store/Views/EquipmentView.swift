import SwiftUI

struct EquipmentView: View {
    @ObservedObject var viewModel: RentingViewModel
    @State private var showCreateGroupView = false
    @State private var showAlert = false
    @State private var groupToDeleteID: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Equipment Inventory")
                            .font(.system(size: 30))
                            .padding(.leading)
                        Spacer()

                        Button(action: {
                            showCreateGroupView = true
                        }) {
                            Image(systemName: "folder.badge.plus")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .padding(.trailing)
                        }
                    }
                    .padding(.vertical)

                    ForEach(viewModel.equipmentGroups, id: \.id) { group in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(group.name)
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    viewModel.addEquipmentToGroup(groupID: group.id)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }

                                Button(action: {
                                    self.groupToDeleteID = group.id
                                    self.showAlert = true
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()

                            let visibleEquipment = self.visibleEquipment(from: group.items)
                            ForEach(visibleEquipment, id: \.id) { equipment in
                                NavigationLink(
                                    destination: EquipmentDetails(equipment: equipment, groupID: group.id, viewModel: viewModel),
                                    label: {
                                        Text(equipment.name)
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
            .background(NavigationLink(destination: CreateGroup(equipmentViewModel: viewModel), isActive: $showCreateGroupView) {
                EmptyView()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Equipment Group"),
                    message: Text("Are you sure you want to delete this group and all its items? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let groupID = self.groupToDeleteID {
                            viewModel.deleteEquipmentGroup(groupID: groupID)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationBarHidden(true)
    }

    // Find the visible equipment based on the name (only the newest with the same name)
    func visibleEquipment(from equipments: [Equipment]) -> [Equipment] {
        var visibleItems: [Equipment] = []

        for equipment in equipments {
            if !visibleItems.contains(where: { $0.name == equipment.name }) {
                visibleItems.append(equipment)
            }
        }

        return visibleItems
    }
}

struct EquipmentView_Previews: PreviewProvider {
    static var previews: some View {
        EquipmentView(viewModel: RentingViewModel())
    }
}
