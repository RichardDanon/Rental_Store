//
//  Rental_StoreApp.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-16.
//

import SwiftUI
import Firebase

@main
struct Rental_StoreApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
