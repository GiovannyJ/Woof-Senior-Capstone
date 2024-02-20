import SwiftUI

struct RegisterBusiness: View {
    @State private var businessName: String = ""
    @State private var businessType: String = ""
    @State private var location: String = ""
    @State private var contact: String = ""
    @State private var description: String = ""
    @State private var events: String = ""
    @State private var petSizePreference: String = "small" // Default value
    
    @State private var registrationStatus: String = ""
    
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
                    Picker("Pet Size Preference", selection: $petSizePreference) {
                        Text("Small").tag("small")
                        Text("Medium").tag("medium")
                        Text("Large").tag("large")
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
        guard let url = URL(string: "http://localhost:8080/businesses") else {
            self.registrationStatus = "Invalid URL"
            return
        }
        
        let body: [String: Any] = [
            "businessName": businessName,
            "businessType": businessType,
            "location": location,
            "contact": contact,
            "description": description,
            "events": events,
            "petSizePref": petSizePreference,
            "dataLocation": "internal"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 201:
                            self.registrationStatus = "Business Registered Successfully!"
                        case 500:
                            self.registrationStatus = "Internal Server Error"
                        default:
                            self.registrationStatus = "Unexpected error occurred"
                        }
                    } else if let error = error {
                        self.registrationStatus = "Error: \(error.localizedDescription)"
                    } else {
                        self.registrationStatus = "Unexpected error occurred"
                    }
                }
            }.resume()
        } catch {
            self.registrationStatus = "Error converting data to JSON"
        }
    }
}

struct RegisterBusiness_Preview: PreviewProvider {
    static var previews: some View {
        RegisterBusiness()
    }
}
