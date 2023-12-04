//
//  ContentView.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-16.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    @State private var selectedTab = 0
    let rentingModel = RentingViewModel()

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
        }.onAppear() {
            FirebaseApp.configure()
            
            var db = Firestore.firestore()
            
            print ("hi234532")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

