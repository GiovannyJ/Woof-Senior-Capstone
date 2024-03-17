//
//  DeleteButton.swift
//  Woof
//
//  Created by Bo Nappie on 3/7/24.
//
import SwiftUI

struct DeleteButton: View {
    let type: String
    let id: Int

    var body: some View {
        Button(action: deleteFromAPI) {
            Text("Delete \(type)")
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(8)
        }
    }

    private func deleteFromAPI() {
        let endpoint: String
        let table: String
        let column: String
        var navigationDestination: AnyView?

        switch type {
        case "Account":
            endpoint = "users"
            table = "user"
            column = "userID"
            navigationDestination = AnyView(LoginView())
        case "Business":
            endpoint = "businesses"
            table = "businesses"
            column = "businessID"
            navigationDestination = AnyView(HomeView())
        case "Event":
            endpoint = "events"
            table = "events"
            column = "eventID"
            navigationDestination = AnyView(HomeView())
        case "Review":
            endpoint = "reviews"
            table = "reviews"
            column = "reviewID"
            navigationDestination = AnyView(HomeView())
        case "SavedBusiness":
            endpoint = "savedBusinesses"
            table = "savedBusiness"
            column = "saveID"
            navigationDestination = AnyView(HomeView())
        default:
            fatalError("Invalid type")
        }
        
        let urlString = "http://localhost:8080/\(endpoint)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "tablename": table,
            "column": column,
            "id": id
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("\(type) deleted successfully")
                DispatchQueue.main.async {
                    if let destination = navigationDestination {
                        // Navigate to the appropriate view
                        // You need to handle navigation in your SwiftUI hierarchy
                        // Here, I'm assuming you're using NavigationView
                        // You might need to adjust this part based on your navigation setup
                        // For simplicity, I'm presenting the destination view directly
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: destination)
                            window.makeKeyAndVisible()
                        }
                    }
                }
            } else {
                print("Failed to delete \(type)")
            }
        }.resume()
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(type: "Account", id: 1)
    }
}
