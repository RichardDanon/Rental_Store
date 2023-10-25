//
//  EquipementView.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-18.
//

import SwiftUI

struct EquipementView: View {
    var body: some View {
        VStack {
            Text("Equipment")
                .navigationTitle("Equipment")
            Button(action: {
                print("Button tapped")
            }) {
                Text("Tap me")
            }
        }
    }
    
}

struct EquipementView_Previews: PreviewProvider {
    static var previews: some View {
        EquipementView()
    }
}
