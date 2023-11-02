import SwiftUI

struct EquipmentView: View {
    @ObservedObject var viewModel: RentingViewModel
    @State private var showCreateGroupView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Equipment Inventory")
                        .font(.largeTitle)
                        .padding()

                    ForEach(viewModel.equipmentGroups.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.equipmentGroups[index].name)
                                    .font(.headline)
                                Spacer()
                                NavigationLink(destination: CreateGroup(), isActive: $showCreateGroupView) {
                                    EmptyView()
                                }
                                Button(action: {
                                    showCreateGroupView = true
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                                Button(action: {}) {
                                    Image(systemName: "trash.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding()

                            ForEach(viewModel.equipmentGroups[index].items, id: \.id) { equipment in
                                NavigationLink(
                                    destination: EquipmentDetails(equipment: equipment),
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
        }
        .navigationBarHidden(true)
    }
    
}

struct EquipmentView_Previews: PreviewProvider {
    static var previews: some View {
        EquipmentView(viewModel: RentingViewModel())
    }
}
