


import SwiftUI

struct RegisterBusiness: View {
    @State private var businessName: String = ""
    @State private var businessType: String = ""
    @State private var location: String = ""
    @State private var contact: String = ""
    @State private var description: String = ""
    @State private var events: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Business Details")
                        .foregroundColor(.teal)
                        .font(.title)
                        .padding(.vertical)
                        .fontWeight(.bold)) {
                TextField("Business Name", text: $businessName)
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
                TextField("Business Type", text: $businessType)
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
                TextField("Location", text: $location)
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
                TextField("Contact", text: $contact)
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
            }
            .cornerRadius(4)
            .padding(.vertical, 5)
            
            Section(header: Text("Additional Information").foregroundColor(.teal)
                        .font(.headline)
                        .padding(.vertical)
                        .fontWeight(.medium)) {
                TextField("Description", text: $description)
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
                TextField("Events", text: $events)
                                .padding()
                                .background(Color.teal.opacity(0.2))
                                .cornerRadius(8)
            }
            .cornerRadius(10)
            .padding(.vertical, 5)
            
            // Nonfunctional button currently but should register business
            Section {
                Button(action: {
                    print("Business Registered!")
                }) {
                    Text("Register Business")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(8)
                        .font(.headline)
                }
                .padding(.vertical)
                .buttonStyle(PlainButtonStyle())
            }
            .cornerRadius(10)
            .padding(.vertical, 5)
        }
    }
}

struct RegisterBusiness_Preview: PreviewProvider {
    static var previews: some View {
        RegisterBusiness()
    }
}
