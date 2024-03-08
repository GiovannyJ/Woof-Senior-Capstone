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
        switch type {
        case "Account":
            endpoint = "user"
        case "Business":
            endpoint = "business"
        case "Event":
            endpoint = "event"
        default:
            fatalError("Invalid type")
        }
        
        let parameters = ["tablename": endpoint, "column": "\(type)ID", "id": "\(id)"]
        
        
        print("Delete \(type) with ID \(id)")
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(type: "Account", id: 1)
    }
}
