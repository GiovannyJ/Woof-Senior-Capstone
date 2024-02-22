import SwiftUI

struct RegisterBusiness: View {
    @State private var businessName: String = ""
    @State private var businessType: String = "Other"
    @State private var location: String = ""
    @State private var contact: String = ""
    @State private var description: String = ""
    @State private var events: String = ""
    @State private var petSizePref: String = "small" // Default value
    @State private var leashPolicy: Bool = true
    @State private var disabledFriendly: Bool = false
    
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
                            Text("Arts & Entertainment").tag("Arts & Entertainment")
                                .foregroundColor(.gray)
                            Text("Active Life").tag("Active Life")
                                .foregroundColor(.gray)
                            Text("Hotels & Travel").tag("Hotels & Travel")
                            Text("Local Flavor").tag("Local Flavor")
                            Text("Restaurants").tag("Restaurants")
                            Text("Shopping").tag("Shopping")
                            Text("Other").tag("Other")
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
                        Picker("Leash Policy", selection: $leashPolicy){
                            Text("Yes").tag(true)
                            Text("No").tag(false)
                        }
                        .padding()
                        .cornerRadius(8)
                        
                        Picker("Disabled Pet Friendly", selection: $disabledFriendly){
                            Text("Yes").tag(true)
                            Text("No").tag(false)
                        }
                        .padding()
                        .cornerRadius(8)
                        
                        Picker("Pet Size Preference", selection: $petSizePref) {
                            Text("Small Pets").tag("small")
                            Text("Medium Pets").tag("medium")
                            Text("Large Pets").tag("large")
                        }
                        .padding()
                        .cornerRadius(8)
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
            "petSizePref": petSizePref,
            "leashPolicy": leashPolicy,
            "disabledFriendly": disabledFriendly,
            "dataLocation": "internal"
        ]
        print(businessData)
        
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
