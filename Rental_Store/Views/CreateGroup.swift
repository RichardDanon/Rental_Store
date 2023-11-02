import SwiftUI

struct CreateGroup: View {
    @State private var groupName = ""
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var equipmentViewModel: RentingViewModel

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
                        
                        Button(action: {
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
                            self.presentationMode.wrappedValue.dismiss()
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
                title: Text("Confirm Creation"),
                message: Text("Do you want to create this group?"),
                primaryButton: .default(Text("OK")) {
                    equipmentViewModel.createEquipmentGroup(withName: groupName)
                    self.presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarHidden(true)
    }
}

struct CreateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroup(equipmentViewModel: RentingViewModel())
    }
}
