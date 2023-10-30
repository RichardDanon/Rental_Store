//
//  EquipementView.swift
//  Rental_Store
//
//  Created by macuser on 2023-10-18.
//

import SwiftUI

import SwiftUI

struct EquipementView: View {
    let mockData: [Container] = [
        Container(title: "Basketball", items: [
            Item(id: 1, name: "Basketball 1"),
            Item(id: 2, name: "Basketball 2"),
            Item(id: 3, name: "Basketball 3"),
        ]),
        Container(title: "Soccer", items: [
            Item(id: 4, name: "Soccer Ball 1"),
            Item(id: 5, name: "Soccer Ball 2"),
        ]),
        Container(title: "Tennis", items: [
            Item(id: 6, name: "Tennis Racket 1"),
            Item(id: 7, name: "Tennis Racket 2"),
            Item(id: 8, name: "Tennis Ball 1"),
        ]),
    ]

    var body: some View {
        NavigationView {
            VStack {
                Text("Equipment Inventory")
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .navigationBarTitleDisplayMode(.inline)

                ScrollView {
                    ForEach(mockData, id: \.id) { container in
                        EquipmentContainerView(container: container)
                            .padding(.vertical, 10)
                    }
                }
            }
        }
    }
}

struct Container: Identifiable {
    let id = UUID()
    var title: String
    var items: [Item]
}

struct Item: Identifiable {
    let id: Int
    var name: String
}

struct EquipmentContainerView: View {
    let container: Container

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(container.title)
                .font(.title)
                .padding(.leading, 20)

            ForEach(container.items, id: \.id) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Button(action: {
                        // Add action for plus button
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }

                    Button(action: {
                        // Add action for trash can icon
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct EquipementView_Previews: PreviewProvider {
    static var previews: some View {
        EquipementView()
    }
}
