//  CreateEventView.swift
//  Woof
//
//  Created by Bo Nappie on 1/23/24.
//

//import SwiftUI
//
//struct CreateEventView: View {
//    // Variables to store user input for event details
//    @State private var eventName: String = ""
//    @State private var eventDescription: String = ""
//    @State private var eventDate: Date = Date()
//    @State private var location: String = ""
//    @State private var contactInfo: String = ""
//    @State private var petSizePref: String = "small"
//    @State private var leashPolicy: Bool = false // Changed to Bool
//    @State private var disabledFriendly: Bool = false // Changed to Bool
//    
//    @ObservedObject private var sessionManager = SessionManager.shared
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Event Information")) {
//                    TextField("Event Name", text: $eventName)
//                    TextField("Event Description", text: $eventDescription)
//                    DatePicker("Date", selection: $eventDate, in: Date()..., displayedComponents: .date)
//                        .datePickerStyle(.compact)
//                        .foregroundColor(.gray)
//                        .padding()
//                        .cornerRadius(8)
//                    TextField("Location", text: $location)
//                    TextField("Contact Information", text: $contactInfo)
//                    Picker("Leash Policy", selection: $leashPolicy){
//                        Text("Yes").tag(true)
//                        Text("No").tag(false)
//                    }
//                    .padding()
//                    .cornerRadius(8)
//                    
//                    Picker("Disabled Pet Friendly", selection: $disabledFriendly){
//                        Text("Yes").tag(true)
//                        Text("No").tag(false)
//                    }
//                    .padding()
//                    .cornerRadius(8)
//                    
//                    Picker("Pet Size Preference", selection: $petSizePref) {
//                        Text("Small Pets").tag("small")
//                        Text("Medium Pets").tag("medium")
//                        Text("Large Pets").tag("large")
//                    }
//                    .padding()
//                    .cornerRadius(8)
//                }
//                
//                // Button to submit the event
//                Section {
//                    Button(action: {
//                        // Call the submitEvent function with the event details
//                        submitEvent(eventName: eventName, eventDescription: eventDescription, eventDate: eventDate, location: location, contactInfo: contactInfo,
//                                    petSizePref: petSizePref, leashPolicy: leashPolicy, disabledFriendly: disabledFriendly )
//                    }) {
//                        Text("Submit Event")
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.teal)
//                            .cornerRadius(8)
//                            .fontWeight(Font.Weight.heavy)
//                    }
//                }
//            }
//            .navigationTitle("Create Event")
//        }
//    }
//    private func submitEvent(eventName: String, eventDescription: String, eventDate: Date, location: String, contactInfo: String, petSizePref: String, leashPolicy: Bool, disabledFriendly: Bool){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" // Specify the desired format
//        let formattedDate = dateFormatter.string(from: eventDate)
//            
//        let businessID = SessionManager.shared.userBusinessID
//        let url = URL(string: "http://localhost:8080/events/businesses/\(businessID ?? 0)")!
//        let body: [String: Any] = [
//            "eventName": eventName,
//            "eventDescription": eventDescription,
//            "eventDate": formattedDate,
//            "location": location,
//            "contactInfo": contactInfo,
//            "petSizePref": petSizePref,
//            "leashPolicy": leashPolicy,
//            "disabledFriendly": disabledFriendly,
//            
//            
//            "datalocation": "internal"
//        ]
//        print(body)
//        
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
//            print("Error encoding data")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let httpResponse = response as? HTTPURLResponse {
//                switch httpResponse.statusCode {
//                case 201:
//                    // Successful response
//                    print("Event Created!")
//                    // Update SessionManager on the main thread
//                    //                DispatchQueue.main.async {
//                    //                    SessionManager.shared.isLoggedIn = true
//                    //                }
//                case 500:
//                    // Handle 500 error
//                    print("Error: \(httpResponse.statusCode)")
//                default:
//                    // Handle other status codes
//                    print("Unexpected error occurred")
//                }
//            }
//        }.resume()
//    }
//    
//}
//struct CreateEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateEventView()
//    }
//}
