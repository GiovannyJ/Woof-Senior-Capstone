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
            }
            .cornerRadius(10)
            .padding(.vertical, 5)
        }
    }
    
    private func registerBusiness() {
        guard let url = URL(string: "http://localhost:8080/CreateNewBusiness") else {
            print("Invalid URL")
            return
        }
        
        // Create a dictionary to hold the business data
        let body: [String: Any] = [
            "businessName": businessName,
            "businessType": businessType,
            "location": location,
            "contact": contact,
            "description": description,
            "events": events
        ]
        
        // Convert dictionary to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error converting data to JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    print("Business Registered Successfully!")
                case 500:
                    print("Internal Server Error")
                default:
                    print("Unexpected error occurred")
                }
            }
        }.resume()
    }
    
    struct RegisterBusiness_Preview: PreviewProvider {
        static var previews: some View {
            RegisterBusiness()
        }
    }
}
