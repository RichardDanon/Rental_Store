//
//  ContentView.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-16.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    let equipmentViewModel = RentingViewModel() // Instantiate the view model

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            EquipmentView(viewModel: equipmentViewModel)
                .tabItem {
                    Label("Equipment", systemImage: "list.dash")
                }
                .tag(1)

            UserView()
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

