import SwiftUI

struct CreateGroup: View {
    @State private var groupName = ""
    
    var body: some View {
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
                        // Implement your logic for creating a new group with groupName
                        // Then navigate back to EquipementView.
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
                        // Implement your logic for navigating back to EquipementView without creating a group.
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
}

struct CreateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroup()
    }
}
