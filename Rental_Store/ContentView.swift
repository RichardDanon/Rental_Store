import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject var rentingModel = RentingViewModel() // Use StateObject for owning the ViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            EquipmentView(viewModel: rentingModel)
                .tabItem {
                    Label("Equipment", systemImage: "list.dash")
                }
                .tag(1)

            UserView(viewModel: rentingModel)
                .tabItem {
                    Label("User's View", systemImage: "person")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
