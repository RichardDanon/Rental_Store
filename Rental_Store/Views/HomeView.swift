//
//  Home.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-18.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                Text("Home")
                    .navigationTitle("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)

            NavigationView {
                Text("Inventory")
                    .navigationTitle("Inventory")
            }
            .tabItem {
                Label("Inventory", systemImage: "list.dash")
            }
            .tag(1)

            NavigationView {
                Text("User's View")
                    .navigationTitle("User's View")
            }
            .tabItem {
                Label("User's View", systemImage: "person")
            }
            .tag(2)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
