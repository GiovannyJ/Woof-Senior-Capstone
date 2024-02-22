import SwiftUI

struct RegisterBusiness: View {
    @State private var businessName: String = ""
    @State private var businessType: String = ""
    @State private var location: String = ""
    @State private var contact: String = ""
    @State private var description: String = ""
    @State private var events: String = ""
    @State private var petSizePreference: String = "small" // Default value
    @State private var leashPolicy: String = ""
    @State private var disabledFriendly: String = ""
    
    @State private var registrationStatus: String = ""
    @ObservedObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        VStack {
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
                        Picker("Business Type", selection: $businessType) {
                            Text("Arts & Entertainment").tag("T1")
                                .foregroundColor(.gray)
                            Text("Active Life").tag("T2")
                                .foregroundColor(.gray)
                            Text("Hotels & Travel").tag("T3")
                            Text("Local Flavor").tag("T5")
                            Text("Restaurants").tag("T6")
                            Text("Shopping").tag("T7")
                            Text("Other").tag("T8")
                        }
                            .pickerStyle(MenuPickerStyle())
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
                        TextField("Leash Policy", text: $leashPolicy)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)
                        TextField("Disabled Pet Friendly", text: $disabledFriendly)
                            .padding()
                            .background(Color.teal.opacity(0.2))
                            .cornerRadius(8)                        
                        Picker("Pet Size Preference", selection: $petSizePreference) {
                            Text("Small Pets").tag("small")
                            Text("Medium Pets").tag("medium")
                            Text("Large Pets").tag("large")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .cornerRadius(10)
                    .padding(.vertical, 5)
            }
            
            Button(action: {
                registerBusiness()
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
            
            Text(registrationStatus)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }
    private func registerBusiness() {
        // Create a dictionary with the  data to register the business
        let businessData: [String: Any] = [
            "businessName": businessName,
            "businessType": businessType,
            "ownerUserID": sessionManager.currentUser?.userID ?? 0,
            "location": location,
            "contact": contact,
            "description": description,
//            "events": events,
            "petSizePref": petSizePreference,
            "leashPolicy": leashPolicy,
            "disabledFriendly": disabledFriendly,
            "dataLocation": "internal"
        ]
        
        // JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: businessData) else {
            print("Error converting data to JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:8080/businesses") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    // Successful response
                    print("Business Registered!")
                    // Update SessionManager on the main thread
//                    DispatchQueue.main.async {
//                        SessionManager.shared.isLoggedIn = true
//                    }
                case 500:
                    // Handle 500 error
                    print("Error: \(httpResponse.statusCode)")
                default:
                    // Handle other status codes
                    print("Unexpected error occurred")
                }
            }
        }.resume()
        struct RegisterBusiness_Preview: PreviewProvider {
            static var previews: some View {
                RegisterBusiness()
            }
        }
    }
}
