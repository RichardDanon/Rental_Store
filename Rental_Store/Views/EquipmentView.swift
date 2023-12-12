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
                            }
                            .padding()

                            ForEach(group.items, id: \.id) { equipment in
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
        }
        .navigationBarHidden(true)
    }
}

struct EquipmentView_Previews: PreviewProvider {
    static var previews: some View {
        EquipmentView(viewModel: RentingViewModel())
    }
}
