import SwiftUI

struct EquipmentDetails: View {
    var equipment: Equipment
    @State private var selectedAvailability: Availability
    
    init(equipment: Equipment) {
        self.equipment = equipment
        _selectedAvailability = State(initialValue: equipment.availability)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(equipment.name) # \(equipment.id)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 20)
            
            CardView(title: "Availabilities") {
                Picker("", selection: $selectedAvailability) {
                    Text("Free").tag(Availability.free)
                    Text("Rented").tag(Availability.rented)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            CardView(title: "Usages") {
                ForEach(equipment.usages, id: \.userName) { usage in
                    HStack {
                        Text("Last User: \(usage.userName)")
                            .font(.body)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("Number of Rentals: \(usage.numberOfRentals)")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
        )
        .padding()
    }
}

struct CardView<Content: View>: View {
    var title: String
    var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
        VStack(alignment: .leading) {

            content
                .padding(.horizontal, 20)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
        .shadow(radius: 5)
    }
}


struct EquipmentDetails_Previews: PreviewProvider {
    static var previews: some View {
        EquipmentDetails(equipment: Equipment(id: "1", name: "Sample Equipment", availability: .free, usages: [Usage(userName: "User1", numberOfRentals: 5)])
    )}
}
