import SwiftUI

struct EquipmentView: View {
    @ObservedObject var viewModel: RentingViewModel
    @State private var showCreateGroupView = false

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

                    ForEach(viewModel.equipmentGroups.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.equipmentGroups[index].name)
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    let groupName = viewModel.equipmentGroups[index].name
                                    let newID = viewModel.getNextEquipmentID(forGroup: viewModel.equipmentGroups[index])
                                    let newItem = Equipment(id: newID, name: groupName, availability: .free, usages: [])
                                    viewModel.equipmentGroups[index].items.append(newItem)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }

                                // Removed Button with the "trash.circle.fill" icon
                            }
                            .padding()

                            ForEach(viewModel.equipmentGroups[index].items, id: \.id) { equipment in
                                NavigationLink(
                                    destination: EquipmentDetails(equipment: equipment, viewModel: viewModel),
                                    label: {
                                        Text("\(equipment.name) #\(equipment.id)")
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
        }
        .navigationBarHidden(true)
        // Removed alert for deletion
    }
}

struct EquipmentView_Previews: PreviewProvider {
    static var previews: some View {
        EquipmentView(viewModel: RentingViewModel())
    }
}
