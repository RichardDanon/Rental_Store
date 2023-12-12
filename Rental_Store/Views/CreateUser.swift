import SwiftUI

struct CreateUser: View {
    @State private var userName = ""
    @State private var userPhoneNumber = ""
    @State private var userEmail = ""
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var rentingViewModel: RentingViewModel

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color(UIColor.systemBackground)
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Create New User")
                            .font(.largeTitle)
                            .foregroundColor(Color.blue)
                            .padding(.bottom, 20)

                        TextField("User Name", text: $userName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)

                        TextField("Phone Number", text: $userPhoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)

                        TextField("Email", text: $userEmail)
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
                message: Text("Do you want to create this user named \(userName)?"),
                primaryButton: .default(Text("OK")) {
                    rentingViewModel.createUser(name: userName, phoneNumber: userPhoneNumber, email: userEmail)
                    self.presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarHidden(true)
    }
}

struct CreateUser_Previews: PreviewProvider {
    static var previews: some View {
        CreateUser(rentingViewModel: RentingViewModel())
    }
}
