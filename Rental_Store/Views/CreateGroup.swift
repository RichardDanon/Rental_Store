import SwiftUI

struct CreateGroup: View {
    @State private var groupName = ""
    @State private var showEquipmentView = false
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode

    let equipmentViewModel = RentingViewModel()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color(UIColor.systemBackground)
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Create New Group")
                            .font(.largeTitle)
                            .foregroundColor(Color.blue)
                            .padding(.bottom, 20)
                        
                        TextField("Group Name", text: $groupName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                        
                        NavigationLink("", destination: EquipmentView(viewModel: equipmentViewModel), isActive: $showEquipmentView)
                        
                        Button(action: {

                            equipmentViewModel.createEquipmentGroup(withName: groupName)

                            showAlert = true
                        }) {
                            Text("Submit")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                        
                        Button(action: {

                            showEquipmentView = true
                        }) {
                            Text("Dismiss")
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Group Created Successfully"),
                message: Text("Your group has been created successfully."),
                primaryButton: .default(Text("OK")) {

                    showEquipmentView = true
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarHidden(true)
    }
}

struct CreateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroup()
    }
}
