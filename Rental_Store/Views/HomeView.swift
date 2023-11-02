import SwiftUI

struct HomeView: View {
    let viewModel = RentingViewModel()
    
    // Modified data for the two homes to include associated views
    let homes: [Home] = [
        .init(name: "User Home",
              description: "Users currently available in the renting system.",
              imageName: "person.3",
              destination: AnyView(UserView(viewModel: RentingViewModel()))),
        .init(name: "Equipment Home",
              description: "For professional rentals and engagements.",
              imageName: "briefcase",
              destination: AnyView(EquipmentView(viewModel: RentingViewModel())))
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ForEach(homes) { home in
                    NavigationLink(destination: home.destination) {
                        HomeTile(home: home)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .navigationTitle("Home")
            .padding()
        }
    }
}

struct HomeTile: View {
    var home: Home
    
    var body: some View {
        HStack {
            Image(systemName: home.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(home.name)
                    .font(.headline)
                Text(home.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct Home: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let destination: AnyView  // Add this line
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
